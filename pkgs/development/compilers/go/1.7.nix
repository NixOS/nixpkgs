{ stdenv, lib, fetchFromGitHub, tzdata, iana_etc, go_1_4, runCommand
, perl, which, pkgconfig, patch, fetchpatch
, pcre
, Security, Foundation, bash }:

let
  goBootstrap = runCommand "go-bootstrap" {} ''
    mkdir $out
    cp -rf ${go_1_4}/* $out/
    chmod -R u+w $out
    find $out -name "*.c" -delete
    cp -rf $out/bin/* $out/share/go/bin/
  '';
in

stdenv.mkDerivation rec {
  name = "go-${version}";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "go";
    rev = "go${version}";
    sha256 = "03wc4r5pgxrlh3lp8l0hb1bhsrwv4hfq1fcj8n82bfk3hvj43am2";
  };

  # perl is used for testing go vet
  nativeBuildInputs = [ perl which pkgconfig patch ];
  buildInputs = [ pcre ];
  propagatedBuildInputs = lib.optionals stdenv.isDarwin [
    Security Foundation
  ];

  hardeningDisable = [ "all" ];

  # I'm not sure what go wants from its 'src', but the go installation manual
  # describes an installation keeping the src.
  preUnpack = ''
    topdir=$PWD
    mkdir -p $out/share
    cd $out/share
  '';

  prePatch = ''
    # Ensure that the source directory is named go
    cd ..
    if [ ! -d go ]; then
      mv * go
    fi

    cd go
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

    sed -i 's,/etc/protocols,${iana_etc}/etc/protocols,' src/net/lookup_unix.go
    sed -i 's,/etc/services,${iana_etc}/etc/services,' src/net/port_unix.go

    # Disable cgo lookup tests not works, they depend on resolver
    rm src/net/cgo_unix_test.go

  '' + lib.optionalString stdenv.isLinux ''
    sed -i 's,/usr/share/zoneinfo/,${tzdata}/share/zoneinfo/,' src/time/zoneinfo_unix.go
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/race.bash --replace \
      "sysctl machdep.cpu.extfeatures | grep -qv EM64T" true
    sed -i 's,strings.Contains(.*sysctl.*,true {,' src/cmd/dist/util.go
    sed -i 's,"/etc","'"$TMPDIR"'",' src/os/os_test.go
    sed -i 's,/_go_os_test,'"$TMPDIR"'/_go_os_test,' src/os/path_test.go

    sed -i '/TestChdirAndGetwd/areturn' src/os/os_test.go
    sed -i '/TestRead0/areturn' src/os/os_test.go
    sed -i '/TestNohup/areturn' src/os/signal/signal_test.go
    sed -i '/TestSystemRoots/areturn' src/crypto/x509/root_darwin_test.go

    sed -i '/TestGoInstallRebuildsStalePackagesInOtherGOPATH/areturn' src/cmd/go/go_test.go
    sed -i '/TestBuildDashIInstallsDependencies/areturn' src/cmd/go/go_test.go

    sed -i '/TestDisasmExtld/areturn' src/cmd/objdump/objdump_test.go

    touch $TMPDIR/group $TMPDIR/hosts $TMPDIR/passwd

    sed -i '1 a\exit 0' misc/cgo/errors/test.bash

    mkdir $topdir/dirtyhacks
    cat <<EOF > $topdir/dirtyhacks/clang
    #!${bash}/bin/bash
    $(type -P clang) "\$@" 2> >(sed '/ld: warning:.*ignoring unexpected dylib file/ d' 1>&2)
    exit $?
    EOF
    chmod +x $topdir/dirtyhacks/clang
    PATH=$topdir/dirtyhacks:$PATH
  '';

  patches = [
    ./remove-tools-1.7.patch
  ];

  GOOS = if stdenv.isDarwin then "darwin" else "linux";
  GOARCH = if stdenv.isDarwin then "amd64"
           else if stdenv.system == "i686-linux" then "386"
           else if stdenv.system == "x86_64-linux" then "amd64"
           else if stdenv.isArm then "arm"
           else throw "Unsupported system";
  GOARM = stdenv.lib.optionalString (stdenv.system == "armv5tel-linux") "5";
  GO386 = 387; # from Arch: don't assume sse2 on i686
  CGO_ENABLED = 1;
  GOROOT_BOOTSTRAP = "${goBootstrap}/share/go";

  # The go build actually checks for CC=*/clang and does something different, so we don't
  # just want the generic `cc` here.
  CC = if stdenv.isDarwin then "clang" else "cc";

  installPhase = ''
    mkdir -p "$out/bin"
    export GOROOT="$(pwd)/"
    export GOBIN="$out/bin"
    export PATH="$GOBIN:$PATH"
    cd ./src
    echo Building
    ./all.bash
  '';

  preFixup = ''
    rm -r $out/share/go/pkg/bootstrap
    rmdir $out/bin && mv $out/share/go/bin $out/bin
  '';

  setupHook = ./setup-hook.sh;

  disallowedReferences = [ go_1_4 ];

  meta = with stdenv.lib; {
    branch = "1.7";
    homepage = http://golang.org/;
    description = "The Go Programming language";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cstrahan wkennington ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
