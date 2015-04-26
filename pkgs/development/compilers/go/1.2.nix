{ stdenv, fetchurl, bison, glibc, bash, coreutils, makeWrapper, tzdata, iana_etc }:

let
  loader386 = "${glibc.out}/lib/ld-linux.so.2";
  loaderAmd64 = "${glibc.out}/lib/ld-linux-x86-64.so.2";
  loaderArm = "${glibc.out}/lib/ld-linux.so.3";
in

stdenv.mkDerivation {
  name = "go-1.2.2";

  src = fetchurl {
    url = https://storage.googleapis.com/golang/go1.2.2.src.tar.gz;
    sha1 = "3ce0ac4db434fc1546fec074841ff40dc48c1167";
  };

  buildInputs = [ bison glibc bash makeWrapper ];

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  # I'm not sure what go wants from its 'src', but the go installation manual
  # describes an installation keeping the src.
  preUnpack = ''
    mkdir -p $out/share
    cd $out/share
  '';

  prePatch = ''
    cd ..
    if [ ! -d go ]; then
      mv * go
    fi
    cd go

    patchShebangs ./ # replace /bin/bash
    # !!! substituteInPlace does not seems to be effective.
    sed -i 's,/lib/ld-linux.so.2,${loader386},' src/cmd/8l/asm.c
    sed -i 's,/lib64/ld-linux-x86-64.so.2,${loaderAmd64},' src/cmd/6l/asm.c
    sed -i 's,/lib64/ld-linux-x86-64.so.3,${loaderArm},' src/cmd/5l/asm.c
    sed -i 's,/usr/share/zoneinfo/,${tzdata}/share/zoneinfo/,' src/pkg/time/zoneinfo_unix.go
    sed -i 's,/etc/protocols,${iana_etc}/etc/protocols,' src/pkg/net/lookup_unix.go

    #sed -i -e 's,/bin/cat,${coreutils}/bin/cat,' \
    #  -e 's,/bin/echo,${coreutils}/bin/echo,' \
    #  src/pkg/exec/exec_test.go

    # Disabling the 'os/http/net' tests (they want files not available in
    # chroot builds)
    rm src/pkg/net/{multicast_test.go,parse_test.go,port_test.go}
    # The os test wants to read files in an existing path. Just it don't be /usr/bin.
    sed -i 's,/usr/bin,'"`pwd`", src/pkg/os/os_test.go
    sed -i 's,/bin/pwd,'"`type -P pwd`", src/pkg/os/os_test.go
    # Disable the hostname test
    sed -i '/TestHostname/areturn' src/pkg/os/os_test.go
    # ParseInLocation fails the test
    sed -i '/TestParseInSydney/areturn' src/pkg/time/time_test.go
  '';

  patches = [ ./cacert-1.2.patch ];

  GOOS = "linux";
  GOARCH = if stdenv.system == "i686-linux" then "386"
          else if stdenv.system == "x86_64-linux" then "amd64"
          else if stdenv.system == "armv5tel-linux" then "arm"
          else throw "Unsupported system";
  GOARM = stdenv.lib.optionalString (stdenv.system == "armv5tel-linux") "5";
  GO386 = 387; # from Arch: don't assume sse2 on i686

  installPhase = ''
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
    branch = "1.2";
    homepage = http://golang.org/;
    description = "The Go Programming language";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [ pierron viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
