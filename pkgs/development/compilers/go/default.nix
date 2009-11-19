{stdenv, fetchhg, bison, glibc, ed, which, bash, makeWrapper, ...}:

let
  version = "2009-11-12";
  md5 = "66e5803c8dc2855b339151918b6b0de5";
in

stdenv.mkDerivation {
  name = "Go-" + version;

  # No tarball yet.
  src = fetchhg {
    url = https://go.googlecode.com/hg/;
    tag = "release." + version;
    inherit md5;
  };

  buildInputs = [ bison glibc ed which bash makeWrapper ];

  patches = [
    ./disable-system-dependent-tests.patch
    ./cgo-set-local-to-match-gcc-error-messages.patch
  ];

  prePatch = ''
    patchShebangs ./ # replace /bin/bash
    # only for 386 build
    # !!! substituteInPlace does not seems to be effective.
    sed -i 's,/lib/ld-linux.so.2,${glibc}/lib/ld-linux.so.2,' src/cmd/8l/asm.c
    sed -i 's,/usr/share/zoneinfo/,${glibc}/share/zoneinfo/,' src/pkg/time/zoneinfo.go
  '';

  GOOS = "linux";
  GOARCH = "386";

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
    maintainers = with stdenv.lib.maintainers; [ pierron ];
  };
}
