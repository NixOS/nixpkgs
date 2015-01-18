{ stdenv, fetchgit, python }:

let
  tag = "1.29.3";
in

stdenv.mkDerivation rec {
  name = "emscripten-fastcomp-${tag}";

  srcFC = fetchgit {
    url = git://github.com/kripken/emscripten-fastcomp;
    rev = "refs/tags/${tag}";
    sha256 = "ab44554dc43eee5552ea04c134a5aaff2cd32f6f6528f58a24025bcd8fd1d46e";
  };

  srcFL = fetchgit {
    url = git://github.com/kripken/emscripten-fastcomp-clang;
    rev = "refs/tags/${tag}";
    sha256 = "cc6dd704f5eba64fda931833479003bf3c8d9cf781bbaac3aa22a7b2644ccb26";
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
