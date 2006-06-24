{stdenv, fetchurl, libtool}:

stdenv.mkDerivation {
  name = "chmlib-0.38";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://66.93.236.84/~jedwin/projects/chmlib/chmlib-0.38.tar.bz2;
    md5 = "8fa5e9a1af13084ca465d9ee09e1946e";
  };
  buildInputs = [libtool];
}
