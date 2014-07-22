{ stdenv, lib, fetchurl, bison, glibc, bash, coreutils, makeWrapper, tzdata, iana_etc }:

let
  loader386 = "${glibc}/lib/ld-linux.so.2";
  loaderAmd64 = "${glibc}/lib/ld-linux-x86-64.so.2";
  loaderArm = "${glibc}/lib/ld-linux.so.3";
in

stdenv.mkDerivation {
  name = "go-1.3";

  src = fetchurl {
    url = https://storage.googleapis.com/golang/go1.3.src.tar.gz;
    sha256 = "10jkqgzlinzynciw3wr15c7n2vw5q4d2ni65hbs3i61bbdn3x67b";
  };

  buildInputs = [ bison bash makeWrapper ] ++ lib.optionals stdenv.isLinux [ glibc ] ;

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
  CGO_ENABLED = 1;

  installPhase = ''
    export CC=cc

    # http://lists.science.uu.nl/pipermail/nix-dev/2013-October/011891.html
    # Fix for "libgcc_s.so.1 must be installed for pthread_cancel to work"
    # during tests:
    export LD_LIBRARY_PATH="$(dirname $(echo ${stdenv.gcc.gcc}/lib/libgcc_s.so))"

    mkdir -p "$out/bin"
    export GOROOT="$(pwd)/"
    export GOBIN="$out/bin"
    export PATH="$GOBIN:$PATH"
    cd ./src
    ./all.bash
    cd -

    # Copy the emacs configuration for Go files.
    mkdir -p "$out/share/emacs/site-lisp"
    cp ./misc/emacs/* $out/share/emacs/site-lisp/
  '';

  meta = {
    homepage = http://golang.org/;
    description = "The Go Programming language";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [ cstrahan ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
