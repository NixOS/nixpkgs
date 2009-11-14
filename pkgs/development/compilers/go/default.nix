{stdenv, fetchhg, bison, glibc, ed, which, bash, ...}:

let
  version = "2009-11-10.1";
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

  buildInputs = [ bison glibc ed which bash ];

  patches = [
    ./disable-system-dependent-tests.patch
    ./pkg-log-test-accept-period-in-file-path.patch
  ];

  prePatch = ''
    patchShebangs ./ # replace /bin/bash
    # only for 386 build
    # !!! substituteInPlace does not seems to be effective.
    sed -i 's,/lib/ld-linux.so.2,${glibc}/lib/ld-linux.so.2,' src/cmd/8l/asm.c
  '';

  GOOS = "linux";
  GOARCH = "386";

  # The go-c interface depends on the error output of GCC.
  LC_ALL = "C";

  installPhase = ''
    ensureDir "$out"
    ensureDir "$out/bin"
    export GOROOT="$(pwd)/"
    export GOBIN="$out/bin"
    export PATH="$GOBIN:$PATH"
    cd ./src
    ./all.bash
    cd -
  '';

  meta = {
    homepage = http://golang.org/;
    description = "The Go Programming language";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [ pierron ];
  };
}
