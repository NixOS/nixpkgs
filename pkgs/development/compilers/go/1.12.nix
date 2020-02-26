{ stdenv, fetchurl, tzdata, iana-etc, runCommand
, perl, which, pkgconfig, patch, procps, pcre, cacert, Security, Foundation
, mailcap, runtimeShell
, buildPackages, pkgsTargetTarget
}:

let

  inherit (stdenv.lib) optionals optionalString;

  goBootstrap = runCommand "go-bootstrap" {} ''
    mkdir $out
    cp -rf ${buildPackages.go_bootstrap}/* $out/
    chmod -R u+w $out
    find $out -name "*.c" -delete
    cp -rf $out/bin/* $out/share/go/bin/
  '';

  goarch = platform: {
    i686 = "386";
    x86_64 = "amd64";
    aarch64 = "arm64";
    arm = "arm";
    armv5tel = "arm";
    armv6l = "arm";
    armv7l = "arm";
  }.${platform.parsed.cpu.name} or (throw "Unsupported system");

in

stdenv.mkDerivation rec {
  pname = "go";
  version = "1.12.17";

  src = fetchurl {
    url = "https://dl.google.com/go/go${version}.src.tar.gz";
    sha256 = "09cbl90maxry713wd18jdqrms3ivbvcm472csnxc78rsqhc851yy";
  };

  # perl is used for testing go vet
  nativeBuildInputs = [ perl which pkgconfig patch procps ];
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
      --replace '#!/usr/bin/env bash' '#!${runtimeShell}'

    # Patch the mimetype database location which is missing on NixOS.
    substituteInPlace src/mime/type_unix.go \
      --replace '/etc/mime.types' '${mailcap}/etc/mime.types'

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

    # Disable TestGcSys because it's flakey in our tests, but the failure is not
    # reproducible by multiple people in other environments.
    # See https://github.com/NixOS/nixpkgs/issues/68361#issuecomment-537849272 and following
    # NOTE: Try re-enabling for releases newer than 1.12.9
    sed -i '/TestGcSys/areturn' src/runtime/gc_test.go

  '' + optionalString stdenv.isLinux ''
    sed -i 's,/usr/share/zoneinfo/,${tzdata}/share/zoneinfo/,' src/time/zoneinfo_unix.go
  '' + optionalString stdenv.isAarch32 ''
    echo '#!${runtimeShell}' > misc/cgo/testplugin/test.bash
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

    # TestCurrent fails because Current is not implemented on Darwin
    sed -i 's/TestCurrent/testCurrent/g' src/os/user/user_test.go
    sed -i 's/TestLookup/testLookup/g' src/os/user/user_test.go

    touch $TMPDIR/group $TMPDIR/hosts $TMPDIR/passwd
  '';

  patches = [
    ./remove-tools-1.11.patch
    ./ssl-cert-file-1.12.1.patch
    ./remove-test-pie.patch
    ./creds-test.patch
    ./go-1.9-skip-flaky-19608.patch
    ./go-1.9-skip-flaky-20072.patch
    ./skip-external-network-tests.patch
    ./skip-nohup-tests.patch
  ] ++ [
    # breaks under load: https://github.com/golang/go/issues/25628
    (if stdenv.isAarch32
    then ./skip-test-extra-files-on-aarch32.patch
    else ./skip-test-extra-files-on-386.patch)
  ];

  postPatch = ''
    find . -name '*.orig' -exec rm {} ';'
  '';

  GOOS = stdenv.targetPlatform.parsed.kernel.name;
  GOARCH = goarch stdenv.targetPlatform;
  # GOHOSTOS/GOHOSTARCH must match the building system, not the host system.
  # Go will nevertheless build a for host system that we will copy over in
  # the install phase.
  GOHOSTOS = stdenv.buildPlatform.parsed.kernel.name;
  GOHOSTARCH = goarch stdenv.buildPlatform;

  # {CC,CXX}_FOR_TARGET must be only set for cross compilation case as go expect those
  # to be different from CC/CXX
  CC_FOR_TARGET = if (stdenv.buildPlatform != stdenv.targetPlatform) then
      "${pkgsTargetTarget.stdenv.cc}/bin/${pkgsTargetTarget.stdenv.cc.targetPrefix}cc"
    else
      null;
  CXX_FOR_TARGET = if (stdenv.buildPlatform != stdenv.targetPlatform) then
      "${pkgsTargetTarget.stdenv.cc}/bin/${pkgsTargetTarget.stdenv.cc.targetPrefix}c++"
    else
      null;

  GOARM = toString (stdenv.lib.intersectLists [(stdenv.hostPlatform.parsed.cpu.version or "")] ["5" "6" "7"]);
  GO386 = 387; # from Arch: don't assume sse2 on i686
  CGO_ENABLED = 1;
  # Hopefully avoids test timeouts on Hydra
  GO_TEST_TIMEOUT_SCALE = 3;

  # Indicate that we are running on build infrastructure
  # Some tests assume things like home directories and users exists
  GO_BUILDER_NAME = "nix";

  GOROOT_BOOTSTRAP="${goBootstrap}/share/go";

  postConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
    # this is compiled into the binary
    export GOROOT_FINAL=$out/share/go

    export PATH=$(pwd)/bin:$PATH

    # Independent from host/target, CC should produce code for the building system.
    export CC=${buildPackages.stdenv.cc}/bin/cc
    ulimit -a
  '';

  postBuild = ''
    (cd src && ./make.bash)
  '';

  doCheck = stdenv.hostPlatform == stdenv.targetPlatform && !stdenv.isDarwin;

  checkPhase = ''
    runHook preCheck
    (cd src && HOME=$TMPDIR GOCACHE=$TMPDIR/go-cache ./run.bash --no-rebuild)
    runHook postCheck
  '';

  preInstall = ''
    rm -r pkg/{bootstrap,obj}
    # Contains the wrong perl shebang when cross compiling,
    # since it is not used for anything we can deleted as well.
    rm src/regexp/syntax/make_perl_groups.pl
  '' + (if (stdenv.buildPlatform != stdenv.hostPlatform) then ''
    mv bin/*_*/* bin
    rmdir bin/*_*
    ${optionalString (!(GOHOSTARCH == GOARCH && GOOS == GOHOSTOS)) ''
      rm -rf pkg/${GOHOSTOS}_${GOHOSTARCH} pkg/tool/${GOHOSTOS}_${GOHOSTARCH}
    ''}
  '' else if (stdenv.hostPlatform != stdenv.targetPlatform) then ''
    rm -rf bin/*_*
    ${optionalString (!(GOHOSTARCH == GOARCH && GOOS == GOHOSTOS)) ''
      rm -rf pkg/${GOOS}_${GOARCH} pkg/tool/${GOOS}_${GOARCH}
    ''}
  '' else "");

  installPhase = ''
    runHook preInstall
    mkdir -p $GOROOT_FINAL
    cp -a bin pkg src lib misc api doc $GOROOT_FINAL
    ln -s $GOROOT_FINAL/bin $out/bin
    runHook postInstall
  '';

  setupHook = ./setup-hook.sh;

  disallowedReferences = [ goBootstrap ];

  meta = with stdenv.lib; {
    branch = "1.12";
    homepage = http://golang.org/;
    description = "The Go Programming language";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cstrahan orivej mic92 rvolosatovs Frostman ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
