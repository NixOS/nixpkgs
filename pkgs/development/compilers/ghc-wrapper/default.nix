{stdenv, ghc, libraries}:

stdenv.mkDerivation {
  name = ghc.name;
  inherit ghc libraries;
  builder = ./builder.sh;
}
