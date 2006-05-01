{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true}:

assert zlib != null;
assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.6.23";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxml2-2.6.23.tar.gz;
    md5 = "0f37385e3ad73cc94db43d6873f4fc3b";
  };

  python = if pythonSupport then python else null;
  inherit pythonSupport;

  buildInputs =  if pythonSupport then [python] else [];
  propagatedBuildInputs = [zlib];
}
