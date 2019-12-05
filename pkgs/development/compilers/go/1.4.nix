{ stdenv, lib, fetchurl, fetchpatch, tzdata, iana-etc, libcCross
, pkgconfig
, pcre
, Security }:

let
  libc = if stdenv ? cross then libcCross else stdenv.cc.libc;
in

stdenv.mkDerivation rec {
  pname = "go";
  version = "1.4-bootstrap-20161024";
  revision = "79d85a4965ea7c46db483314c3981751909d7883";

  src = fetchurl {
    url = "https://github.com/golang/go/archive/${revision}.tar.gz";
    sha256 = "1ljbllwjysya323xxm9s792z8y9jdw19n8sj3mlc8picjclrx5xf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pcre ];
  propagatedBuildInputs = lib.optional stdenv.isDarwin Security;

  hardeningDisable = [ "all" ];

  # The tests try to do stuff with 127.0.0.1 and localhost
  __darwinAllowLocalNetworking = true;

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

    sed -i 's,/etc/protocols,${iana-etc}/etc/protocols,' src/net/lookup_unix.go
  '' + lib.optionalString stdenv.isLinux ''
    # prepend the nix path to the zoneinfo files but also leave the original value for static binaries
    # that run outside a nix server
    sed -i 's,\"/usr/share/zoneinfo/,"${tzdata}/share/zoneinfo/\"\,\n\t&,' src/time/zoneinfo_unix.go

    # Find the loader dynamically
    LOADER="$(find ${lib.getLib libc}/lib -name ld-linux\* | head -n 1)"

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

    # unix socket tests fail on darwin
    sed -i '/TestConnAndListener/areturn' src/net/conn_test.go
    sed -i '/TestPacketConn/areturn' src/net/conn_test.go
    sed -i '/TestPacketConn/areturn' src/net/packetconn_test.go
    sed -i '/TestConnAndPacketConn/areturn' src/net/packetconn_test.go
    sed -i '/TestUnixListenerSpecificMethods/areturn' src/net/packetconn_test.go
    sed -i '/TestUnixConnSpecificMethods/areturn' src/net/packetconn_test.go
    sed -i '/TestUnixListenerSpecificMethods/areturn' src/net/protoconn_test.go
    sed -i '/TestUnixConnSpecificMethods/areturn' src/net/protoconn_test.go
    sed -i '/TestStreamConnServer/areturn' src/net/server_test.go
    sed -i '/TestReadUnixgramWithUnnamedSocket/areturn' src/net/unix_test.go
    sed -i '/TestReadUnixgramWithZeroBytesBuffer/areturn' src/net/unix_test.go
    sed -i '/TestUnixgramWrite/areturn' src/net/unix_test.go
    sed -i '/TestUnixConnLocalAndRemoteNames/areturn' src/net/unix_test.go
    sed -i '/TestUnixgramConnLocalAndRemoteNames/areturn' src/net/unix_test.go
    sed -i '/TestWithSimulated/areturn' src/log/syslog/syslog_test.go
    sed -i '/TestFlap/areturn' src/log/syslog/syslog_test.go
    sed -i '/TestNew/areturn' src/log/syslog/syslog_test.go
    sed -i '/TestNewLogger/areturn' src/log/syslog/syslog_test.go
    sed -i '/TestDial/areturn' src/log/syslog/syslog_test.go
    sed -i '/TestWrite/areturn' src/log/syslog/syslog_test.go
    sed -i '/TestConcurrentWrite/areturn' src/log/syslog/syslog_test.go
    sed -i '/TestConcurrentReconnect/areturn' src/log/syslog/syslog_test.go

    # remove IP resolving tests, on darwin they can find fe80::1%lo while expecting ::1
    sed -i '/TestResolveIPAddr/areturn' src/net/ipraw_test.go
    sed -i '/TestResolveTCPAddr/areturn' src/net/tcp_test.go
    sed -i '/TestResolveUDPAddr/areturn' src/net/udp_test.go

    sed -i '/TestCgoExternalThreadSIGPROF/areturn' src/runtime/crash_cgo_test.go

    touch $TMPDIR/group $TMPDIR/hosts $TMPDIR/passwd
  '';

  patches = [
    ./remove-tools-1.4.patch
    ./creds-test-1.4.patch

    # This test checks for the wrong thing with recent tzdata. It's been fixed in master but the patch
    # actually works on old versions too.
    (fetchpatch {
      url    = "https://github.com/golang/go/commit/91563ced5897faf729a34be7081568efcfedda31.patch";
      sha256 = "1ny5l3f8a9dpjjrnjnsplb66308a0x13sa0wwr4j6yrkc8j4qxqi";
    })
  ];

  GOOS = if stdenv.isDarwin then "darwin" else "linux";
  GOARCH = if stdenv.isDarwin then "amd64"
           else if stdenv.hostPlatform.system == "i686-linux" then "386"
           else if stdenv.hostPlatform.system == "x86_64-linux" then "amd64"
           else if stdenv.isAarch32 then "arm"
           else throw "Unsupported system";
  GOARM = stdenv.lib.optionalString (stdenv.hostPlatform.system == "armv5tel-linux") "5";
  GO386 = 387; # from Arch: don't assume sse2 on i686
  CGO_ENABLED = 0;

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

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    branch = "1.4";
    homepage = http://golang.org/;
    description = "The Go Programming language";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
