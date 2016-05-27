{ stdenv, fetchFromGitHub, python }:

let
  rev = "1.36.4";
in

stdenv.mkDerivation {
  name = "emscripten-fastcomp-${rev}";

  srcFC = fetchFromGitHub {
    owner = "kripken";
    repo = "emscripten-fastcomp";
    sha256 = "0838rl0n9hyq5dd0gmj5rvigbmk5mhrhzyjk0zd8mjs2mk8z510l";
    inherit rev;
  };

  srcFL = fetchFromGitHub {
    owner = "kripken";
    repo = "emscripten-fastcomp-clang";
    sha256 = "169hfabamv3jmf88flhl4scwaxdh24196gwpz3sdb26lzcns519q";
    inherit rev;
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
    maintainers = with maintainers; [ qknight matthewbauer ];
    license = stdenv.lib.licenses.ncsa;
  };
}
