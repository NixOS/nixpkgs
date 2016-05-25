{ stdenv, fetchgit, python }:

let
  tag = "1.36.4";
in

stdenv.mkDerivation rec {
  name = "emscripten-fastcomp-${tag}";

  srcFC = fetchgit {
    url = git://github.com/kripken/emscripten-fastcomp;
    rev = "refs/tags/${tag}";
    sha256 = "0qmrc83yrlmlb11gqixxnwychif964054lgdiycz0l10yj0q37j5";
  };

  srcFL = fetchgit {
    url = git://github.com/kripken/emscripten-fastcomp-clang;
    rev = "refs/tags/${tag}";
    sha256 = "1av58y9s24l32hsdgp3jh4fkc5005xbzzjd27in2r9q3p6igd5d4";
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
    maintainers = with maintainers; [ qknight ];
    license = stdenv.lib.licenses.ncsa;
  };
}
