{stdenv}:

stdenv.mkDerivation {
  name = "perl";
  builder = ./builder.sh;
}
