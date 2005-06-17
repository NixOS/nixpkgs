{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true}:

assert zlib != null;
assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.6.19";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2-2.6.19.tar.gz;
    md5 = "61587d43389a414fc2f5223b428e325e";
  };

  python = if pythonSupport then python else null;
  inherit pythonSupport;

  buildInputs =  if pythonSupport then [python] else [];
  propagatedBuildInputs = [zlib];
}
