{ stdenv, lib, fetchurl, tzdata, iana_etc, libcCross
, pkgconfig
, pcre
, Security }:

let
  libc = if stdenv ? "cross" then libcCross else stdenv.cc.libc;
in

stdenv.mkDerivation rec {
  name = "go-${version}";
  version = "1.4.3";

  src = fetchurl {
    url = "https://github.com/golang/go/archive/go${version}.tar.gz";
    sha256 = "0rcrhb3r997dw3d02r37zp26ln4q9n77fqxbnvw04zs413md5s35";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pcre ];
  propagatedBuildInputs = lib.optional stdenv.isDarwin Security;

  # I'm not sure what go wants from its 'src', but the go installation manual
  # describes an installation keeping the src.
  preUnpack = ''
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

    # Disabling the 'os/http/net' tests (they want files not available in
    # chroot builds)
    rm src/net/{multicast_test.go,parse_test.go,port_test.go}
    # !!! substituteInPlace does not seems to be effective.
    # The os test wants to read files in an existing path. Just don't let it be /usr/bin.
    sed -i 's,/usr/bin,'"`pwd`", src/os/os_test.go
    sed -i 's,/bin/pwd,'"`type -P pwd`", src/os/os_test.go
    # Disable the unix socket test
    sed -i '/TestShutdownUnix/areturn' src/net/net_test.go
    # Disable network timeout test
    sed -i '/TestDialTimeout/areturn' src/net/dial_test.go
    # Disable the hostname test
    sed -i '/TestHostname/areturn' src/os/os_test.go
    # ParseInLocation fails the test
    sed -i '/TestParseInSydney/areturn' src/time/format_test.go

    sed -i 's,/etc/protocols,${iana_etc}/etc/protocols,' src/net/lookup_unix.go
  '' + lib.optionalString stdenv.isLinux ''
    sed -i 's,/usr/share/zoneinfo/,${tzdata}/share/zoneinfo/,' src/time/zoneinfo_unix.go

    # Find the loader dynamically
    LOADER="$(find ${libc.out or libc}/lib -name ld-linux\* | head -n 1)"

    # Replace references to the loader
    find src/cmd -name asm.c -exec sed -i "s,/lib/ld-linux.*\.so\.[0-9],$LOADER," {} \;
  '' + lib.optionalString stdenv.isDarwin ''
    sed -i 's,"/etc","'"$TMPDIR"'",' src/os/os_test.go
    sed -i 's,/_go_os_test,'"$TMPDIR"'/_go_os_test,' src/os/path_test.go
    sed -i '/TestCgoLookupIP/areturn' src/net/cgo_unix_test.go
    sed -i '/TestChdirAndGetwd/areturn' src/os/os_test.go
    sed -i '/TestDialDualStackLocalhost/areturn' src/net/dial_test.go
    sed -i '/TestRead0/areturn' src/os/os_test.go
    sed -i '/TestSystemRoots/areturn' src/crypto/x509/root_darwin_test.go

    # fails when running inside tmux
    sed -i '/TestNohup/areturn' src/os/signal/signal_test.go


    # remove IP resolving tests, on darwin they can find fe80::1%lo while expecting ::1
    sed -i '/TestResolveIPAddr/areturn' src/net/ipraw_test.go
    sed -i '/TestResolveTCPAddr/areturn' src/net/tcp_test.go
    sed -i '/TestResolveUDPAddr/areturn' src/net/udp_test.go

    sed -i '/TestCgoExternalThreadSIGPROF/areturn' src/runtime/crash_cgo_test.go

    touch $TMPDIR/group $TMPDIR/hosts $TMPDIR/passwd
  '';

  patches = [
    ./remove-tools-1.4.patch
    ./new-binutils.patch
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

  # The go build actually checks for CC=*/clang and does something different, so we don't
  # just want the generic `cc` here.
  CC = if stdenv.isDarwin then "clang" else "cc";

  installPhase = ''
    mkdir -p "$out/bin"
    export GOROOT="$(pwd)/"
    export GOBIN="$out/bin"
    export PATH="$GOBIN:$PATH"
    cd ./src
    ./all.bash
  '';

  stripDebugList = [ "bin" "share" ];

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    branch = "1.4";
    homepage = http://golang.org/;
    description = "The Go Programming language";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cstrahan wkennington ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
