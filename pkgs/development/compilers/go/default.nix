{stdenv, fetchhg, bison, glibc, ed, which, bash, makeWrapper, perl, ...}:

let
  version = "2010-06-09";
  sha256 = "b607879b333ef100466c726a13cc69ed143566a3c1af59f6d33a6e90b9d0c917";

  loader386 = "${glibc}/lib/ld-linux.so.2";
  loaderAmd64 = "${glibc}/lib/ld-linux-x86-64.so.2";
in

stdenv.mkDerivation {
  name = "go-" + version;

  # No tarball yet.
  src = fetchhg {
    url = https://go.googlecode.com/hg/;
    tag = "release." + version;
    inherit sha256;
  };

  buildInputs = [ bison glibc ed which bash makeWrapper ];

  prePatch = ''
    patchShebangs ./ # replace /bin/bash
    # only for 386 build
    # !!! substituteInPlace does not seems to be effective.
    sed -i 's,/lib/ld-linux.so.2,${loader386},' src/cmd/8l/asm.c
    sed -i 's,/lib64/ld-linux-x86-64.so.2,${loaderAmd64},' src/cmd/6l/asm.c
    sed -i 's,/usr/share/zoneinfo/,${glibc}/share/zoneinfo/,' src/pkg/time/zoneinfo.go
    sed -i 's,/bin/ed,${ed}/bin/ed,' src/cmd/6l/mkenam

    sed -i -e 's,/bin/cat,${stdenv.coreutils}/bin/cat,' \
      -e 's,/bin/echo,${stdenv.coreutils}/bin/echo,' \
      src/pkg/exec/exec_test.go

    # Disabling the 'os/http/net' tests (they want files not available in
    # chroot builds)
    sed -i -e '/^NOTEST=/a\\tos\\\n\thttp\\\n\tnet\\' src/pkg/Makefile

    sed -i -e 's,/bin:/usr/bin:/usr/local/bin,'$PATH, test/run
    sed -i -e 's,/usr/bin/perl,${perl}/bin/perl,' test/errchk
  '';

  GOOS = "linux";
  GOARCH = if (stdenv.system == "i686-linux") then "386"
          else if (stdenv.system == "x86_64-linux") then "amd64"
          else throw "Unsupported system";

  installPhase = ''
    ensureDir "$out/bin"
    export GOROOT="$(pwd)/"
    export GOBIN="$out/bin"
    export PATH="$GOBIN:$PATH"
    cd ./src
    ./all.bash
    cd -

    # Handle Libraries and make them availabale under /share/go.
    export GOLIB="pkg/"$GOOS"_"$GOARCH
    ensureDir "$out/lib/go/$GOLIB"
    cp -r ./$GOLIB $out/lib/go/pkg/

    # this line set $AS $CC $GC $LD
    source ./src/Make.$GOARCH

    # Wrap the compiler and the linker to define the location of the
    # libraries.
    wrapProgram "$out/bin/$GC" \
      --add-flags "-I" \
      --add-flags "$out/lib/go/$GOLIB"

    wrapProgram "$out/bin/$LD" \
      --set "GOROOT" "$out/lib/go/" \
      --set "GOOS" "$GOOS" \
      --set "GOARCH" "$GOARCH"

    # Copy the emacs configuration for Go files.
    ensureDir "$out/share/emacs/site-lisp"
    cp ./misc/emacs/* $out/share/emacs/site-lisp/ # */
  '';

  meta = {
    homepage = http://golang.org/;
    description = "The Go Programming language";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [ pierron viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
