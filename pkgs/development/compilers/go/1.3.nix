{ stdenv, lib, fetchurl, fetchhg, bison, glibc, bash, coreutils, makeWrapper, tzdata, iana_etc, perl }:

let
  loader386 = "${glibc.out}/lib/ld-linux.so.2";
  loaderAmd64 = "${glibc.out}/lib/ld-linux-x86-64.so.2";
  loaderArm = "${glibc.out}/lib/ld-linux.so.3";
  srcs = {
    golang = fetchurl {
      url = https://storage.googleapis.com/golang/go1.3.3.src.tar.gz;
      sha1 = "b54b7deb7b7afe9f5d9a3f5dd830c7dede35393a";
    };
    tools = fetchhg {
      url = https://code.google.com/p/go.tools/;
      rev = "e1c276c4e679";
      sha256 = "0x62njflwkd99i2ixbksg6mjppl1wfg86f0g3swn350l1h0xzp76";
    };
  };
in

stdenv.mkDerivation {
  name = "go-1.3.3";

  src = srcs.golang;

  # perl is used for testing go vet
  buildInputs = [ bison bash makeWrapper perl ] ++ lib.optionals stdenv.isLinux [ glibc ] ;

  # I'm not sure what go wants from its 'src', but the go installation manual
  # describes an installation keeping the src.
  preUnpack = ''
    mkdir -p $out/share
    cd $out/share
  '';
  postUnpack = ''
    mkdir -p $out/share/go/src/pkg/code.google.com/p/
    cp -rv --no-preserve=mode,ownership ${srcs.tools} $out/share/go/src/pkg/code.google.com/p/go.tools
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
    rm src/pkg/net/{multicast_test.go,parse_test.go,port_test.go}
    # !!! substituteInPlace does not seems to be effective.
    # The os test wants to read files in an existing path. Just don't let it be /usr/bin.
    sed -i 's,/usr/bin,'"`pwd`", src/pkg/os/os_test.go
    sed -i 's,/bin/pwd,'"`type -P pwd`", src/pkg/os/os_test.go
    # Disable the unix socket test
    sed -i '/TestShutdownUnix/areturn' src/pkg/net/net_test.go
    # Disable the hostname test
    sed -i '/TestHostname/areturn' src/pkg/os/os_test.go
    sed -i 's,/etc/protocols,${iana_etc}/etc/protocols,' src/pkg/net/lookup_unix.go
    # ParseInLocation fails the test
    sed -i '/TestParseInSydney/areturn' src/pkg/time/format_test.go
  '' + lib.optionalString stdenv.isLinux ''
    sed -i 's,/usr/share/zoneinfo/,${tzdata}/share/zoneinfo/,' src/pkg/time/zoneinfo_unix.go
    sed -i 's,/lib/ld-linux.so.3,${loaderArm},' src/cmd/5l/asm.c
    sed -i 's,/lib64/ld-linux-x86-64.so.2,${loaderAmd64},' src/cmd/6l/asm.c
    sed -i 's,/lib/ld-linux.so.2,${loader386},' src/cmd/8l/asm.c
  '';

  patches = [ ./cacert-1.2.patch ];

  GOOS = if stdenv.isDarwin then "darwin" else "linux";
  GOARCH = if stdenv.isDarwin then "amd64"
           else if stdenv.system == "i686-linux" then "386"
           else if stdenv.system == "x86_64-linux" then "amd64"
           else if stdenv.system == "armv5tel-linux" then "arm"
           else throw "Unsupported system";
  GOARM = stdenv.lib.optionalString (stdenv.system == "armv5tel-linux") "5";
  GO386 = 387; # from Arch: don't assume sse2 on i686
  CGO_ENABLED = if stdenv.isDarwin then 0 else 1;

  installPhase = ''
    export CC=cc
    mkdir -p "$out/bin"
    unset GOPATH
    export GOROOT="$(pwd)/"
    export GOBIN="$out/bin"
    export PATH="$GOBIN:$PATH"
    cd ./src
    ./all.bash
    cd -

    # Build extra tooling
    # TODO: Fix godoc tests
    TOOL_ROOT=code.google.com/p/go.tools/cmd
    go install -v $TOOL_ROOT/cover $TOOL_ROOT/vet $TOOL_ROOT/godoc
    go test -v    $TOOL_ROOT/cover $TOOL_ROOT/vet # $TOOL_ROOT/godoc

    # Copy the emacs configuration for Go files.
    mkdir -p "$out/share/emacs/site-lisp"
    cp ./misc/emacs/* $out/share/emacs/site-lisp/
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    branch = "1.3";
    homepage = http://golang.org/;
    description = "The Go Programming language";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [ cstrahan ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
