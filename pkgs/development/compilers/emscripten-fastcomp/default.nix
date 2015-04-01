{ stdenv, fetchgit, python }:

let
  tag = "1.29.10";
in

stdenv.mkDerivation rec {
  name = "emscripten-fastcomp-${tag}";

  srcFC = fetchgit {
    url = git://github.com/kripken/emscripten-fastcomp;
    rev = "refs/tags/${tag}";
    sha256 = "eee0f884c7e10e1b869b9d3afbb03bf69c63ec0560b136e3e8cd64ca00a41653";
  };

  srcFL = fetchgit {
    url = git://github.com/kripken/emscripten-fastcomp-clang;
    rev = "refs/tags/${tag}";
    sha256 = "22c48e85dfacd9f2349d37fb421f0f848b65fc7b39e66984d04349ee3271667c";
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
