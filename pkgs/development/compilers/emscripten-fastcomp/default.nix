{ stdenv, fetchgit, python }:

let
  tag = "1.35.4";
in

stdenv.mkDerivation rec {
  name = "emscripten-fastcomp-${tag}";

  srcFC = fetchgit {
    url = git://github.com/kripken/emscripten-fastcomp;
    rev = "refs/tags/${tag}";
    sha256 = "3bd50787d78381f684f9b3f46fc91cc3d1803c3389e19ec41ee59c2deaf727d8";
  };

  srcFL = fetchgit {
    url = git://github.com/kripken/emscripten-fastcomp-clang;
    rev = "refs/tags/${tag}";
    sha256 = "ec0d22c04eec5f84695401e19a52704b28e8d2779b87388f399b5f63b54a9862";
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
    platforms = platforms.all;
    maintainers = with maintainers; [ bosu ];
    license = stdenv.lib.licenses.ncsa;
  };
}
