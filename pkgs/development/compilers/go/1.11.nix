{ stdenv, fetchFromGitHub, tzdata, iana-etc, go_bootstrap, runCommand, writeScriptBin
, perl, which, pkgconfig, patch, procps
, pcre, cacert, llvm
, Security, Foundation
, makeWrapper, git, subversion, mercurial, bazaar }:

let

  inherit (stdenv.lib) optionals optionalString;

  clangHack = writeScriptBin "clang" ''
    #!${stdenv.shell}
    exec ${stdenv.cc}/bin/clang "$@" 2> >(sed '/ld: warning:.*ignoring unexpected dylib file/ d' 1>&2)
  '';

  goBootstrap = runCommand "go-bootstrap" {} ''
    mkdir $out
    cp -rf ${go_bootstrap}/* $out/
    chmod -R u+w $out
    find $out -name "*.c" -delete
    cp -rf $out/bin/* $out/share/go/bin/
  '';

in

stdenv.mkDerivation rec {
  name = "go-${version}";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "go";
    rev = "go${version}";
    sha256 = "1k18d6rkijlgzn1zw4wphzcv6a6w9hb1msgrsh1102jb18644f2q";
  };

  GOCACHE = "off";

  # perl is used for testing go vet
  nativeBuildInputs = [ perl which pkgconfig patch makeWrapper procps ];
  buildInputs = [ cacert pcre ]
    ++ optionals stdenv.isLinux [ stdenv.cc.libc.out ]
    ++ optionals (stdenv.hostPlatform.libc == "glibc") [ stdenv.cc.libc.static ];
  propagatedBuildInputs = optionals stdenv.isDarwin [ Security Foundation ];

  hardeningDisable = [ "all" ];

  prePatch = ''
    patchShebangs ./ # replace /bin/bash

    # This source produces shell script at run time,
    # and thus it is not corrected by patchShebangs.
    substituteInPlace misc/cgo/testcarchive/carchive_test.go \
      --replace '#!/usr/bin/env bash' '#!${stdenv.shell}'

    # Disabling the 'os/http/net' tests (they want files not available in
    # chroot builds)
    rm src/net/{listen,parse}_test.go
    rm src/syscall/exec_linux_test.go

    # !!! substituteInPlace does not seems to be effective.
    # The os test wants to read files in an existing path. Just don't let it be /usr/bin.
    sed -i 's,/usr/bin,'"`pwd`", src/os/os_test.go
    sed -i 's,/bin/pwd,'"`type -P pwd`", src/os/os_test.go
    # Disable the unix socket test
    sed -i '/TestShutdownUnix/areturn' src/net/net_test.go
    # Disable the hostname test
    sed -i '/TestHostname/areturn' src/os/os_test.go
    # ParseInLocation fails the test
    sed -i '/TestParseInSydney/areturn' src/time/format_test.go
    # Remove the api check as it never worked
    sed -i '/src\/cmd\/api\/run.go/ireturn nil' src/cmd/dist/test.go
    # Remove the coverage test as we have removed this utility
    sed -i '/TestCoverageWithCgo/areturn' src/cmd/go/go_test.go
    # Remove the timezone naming test
    sed -i '/TestLoadFixed/areturn' src/time/time_test.go
    # Remove disable setgid test
    sed -i '/TestRespectSetgidDir/areturn' src/cmd/go/internal/work/build_test.go
    # Remove cert tests that conflict with NixOS's cert resolution
    sed -i '/TestEnvVars/areturn' src/crypto/x509/root_unix_test.go
    # TestWritevError hangs sometimes
    sed -i '/TestWritevError/areturn' src/net/writev_test.go
    # TestVariousDeadlines fails sometimes
    sed -i '/TestVariousDeadlines/areturn' src/net/timeout_test.go

    sed -i 's,/etc/protocols,${iana-etc}/etc/protocols,' src/net/lookup_unix.go
    sed -i 's,/etc/services,${iana-etc}/etc/services,' src/net/port_unix.go

    # Disable cgo lookup tests not works, they depend on resolver
    rm src/net/cgo_unix_test.go

  '' + optionalString stdenv.isLinux ''
    sed -i 's,/usr/share/zoneinfo/,${tzdata}/share/zoneinfo/,' src/time/zoneinfo_unix.go
  '' + optionalString stdenv.isAarch32 ''
    echo '#!${stdenv.shell}' > misc/cgo/testplugin/test.bash
  '' + optionalString stdenv.isDarwin ''
    substituteInPlace src/race.bash --replace \
      "sysctl machdep.cpu.extfeatures | grep -qv EM64T" true
    sed -i 's,strings.Contains(.*sysctl.*,true {,' src/cmd/dist/util.go
    sed -i 's,"/etc","'"$TMPDIR"'",' src/os/os_test.go
    sed -i 's,/_go_os_test,'"$TMPDIR"'/_go_os_test,' src/os/path_test.go

    sed -i '/TestChdirAndGetwd/areturn' src/os/os_test.go
    sed -i '/TestCredentialNoSetGroups/areturn' src/os/exec/exec_posix_test.go
    sed -i '/TestRead0/areturn' src/os/os_test.go
    sed -i '/TestSystemRoots/areturn' src/crypto/x509/root_darwin_test.go

    sed -i '/TestGoInstallRebuildsStalePackagesInOtherGOPATH/areturn' src/cmd/go/go_test.go
    sed -i '/TestBuildDashIInstallsDependencies/areturn' src/cmd/go/go_test.go

    sed -i '/TestDisasmExtld/areturn' src/cmd/objdump/objdump_test.go

    sed -i 's/unrecognized/unknown/' src/cmd/link/internal/ld/lib.go

    touch $TMPDIR/group $TMPDIR/hosts $TMPDIR/passwd
  '';

  patches = [
    ./remove-tools-1.11.patch
    ./ssl-cert-file-1.9.patch
    ./remove-test-pie.patch
    ./creds-test.patch
    ./go-1.9-skip-flaky-19608.patch
    ./go-1.9-skip-flaky-20072.patch
    ./remove-fhs-test-references.patch
    ./skip-external-network-tests.patch
    ./skip-nohup-tests.patch
  ];

  postPatch = optionalString stdenv.isDarwin ''
    echo "substitute hardcoded dsymutil with ${llvm}/bin/llvm-dsymutil"
    substituteInPlace "src/cmd/link/internal/ld/lib.go" --replace dsymutil ${llvm}/bin/llvm-dsymutil
  '';

  GOOS = if stdenv.isDarwin then "darwin" else "linux";
  GOARCH = if stdenv.isDarwin then "amd64"
           else if stdenv.targetPlatform.isi686 then "386"
           else if stdenv.targetPlatform.isx86_64 then "amd64"
           else if stdenv.targetPlatform.isAarch32 then "arm"
           else if stdenv.targetPlatform.isAarch64 then "arm64"
           else throw "Unsupported system";
  GOARM = stdenv.targetPlatform.parsed.cpu.version or "";
  GO386 = 387; # from Arch: don't assume sse2 on i686
  CGO_ENABLED = 1;
  GOROOT_BOOTSTRAP = "${goBootstrap}/share/go";
  # Hopefully avoids test timeouts on Hydra
  GO_TEST_TIMEOUT_SCALE = 3;

  # The go build actually checks for CC=*/clang and does something different, so we don't
  # just want the generic `cc` here.
  CC = if stdenv.isDarwin then "clang" else "cc";

  configurePhase = ''
    # Indicate that we are running on build infrastructure
    # Some tests assume things like home directories and users exists
    export GO_BUILDER_NAME=nix

    mkdir -p $out/share/go/bin
    export GOROOT=$out/share/go
    export GOBIN=$GOROOT/bin
    export PATH=$GOBIN:$PATH
    ulimit -a
  '';

  postConfigure = optionalString stdenv.isDarwin ''
    export PATH=${clangHack}/bin:$PATH
  '';

  installPhase = ''
    cp -r . $GOROOT
    ( cd $GOROOT/src && ./all.bash )

    # (https://github.com/golang/go/wiki/GoGetTools)
    wrapProgram $out/share/go/bin/go --prefix PATH ":" "${stdenv.lib.makeBinPath [ git subversion mercurial bazaar ]}"
  '';

  preFixup = ''
    rm -r $out/share/go/pkg/bootstrap
    ln -s $out/share/go/bin $out/bin
  '';

  setupHook = ./setup-hook.sh;

  disallowedReferences = [ go_bootstrap ];

  meta = with stdenv.lib; {
    branch = "1.9";
    homepage = http://golang.org/;
    description = "The Go Programming language";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cstrahan orivej velovix mic92 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
