{stdenv, ghc, libraries}:

stdenv.mkDerivation {
  inherit (ghc) name meta;
  inherit ghc libraries;
  builder = ./builder.sh;
}
