{ stdenv, fetchgit, python }:

let
  tag = "1.21.0";
in

stdenv.mkDerivation rec {
  name = "emscripten-fastcomp-${tag}";

  srcFC = fetchgit {
    url = git://github.com/kripken/emscripten-fastcomp;
    rev = "refs/tags/${tag}";
    sha256 = "0mcxzg2cfg0s1vfm3bh1ar4xsddb6xkv1dsdbgnpx38lbj1mvfs1";
  };

  srcFL = fetchgit {
    url = git://github.com/kripken/emscripten-fastcomp-clang;
    rev = "refs/tags/${tag}";
    sha256 = "0s2jcn36d236cfpryjpgaazjp3cg83d0h78g6kk1j6vdppv3vgnp";
  };

  buildInputs = [ python ];
  buildCommand = ''
    cp -as ${srcFC} $TMPDIR/src
    chmod +w $TMPDIR/src/tools
    cp -as ${srcFL} $TMPDIR/src/tools/clang

    chmod +w $TMPDIR/src
    mkdir $TMPDIR/src/build
    cd $TMPDIR/src/build

    ../configure --enable-optimized --disable-assertions --enable-targets=host,js
    make
    cp -a Release/bin $out
  '';
  meta = with stdenv.lib; {
    homepage = https://github.com/kripken/emscripten-fastcomp;
    description = "emscripten llvm";
    maintainers = with maintainers; [ bosu ];
    license = stdenv.lib.licenses.ncsa;
  };
}
