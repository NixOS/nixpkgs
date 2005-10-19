{stdenv, fetchurl, libtool}:

stdenv.mkDerivation {
  name = "chmlib-0.36";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://66.93.236.84/%7Ejedwin/projects/chmlib/chmlib-0.36.tbz;
    md5 = "8fa5e9a1af13084ca465d9ee09e1946e";
  };
  buildInputs = [libtool];
}
