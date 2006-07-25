{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true}:

assert zlib != null;
assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.6.26";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxml2-2.6.26.tar.gz;
    md5 = "2d8d3805041edab967368b497642f981";
  };

  python = if pythonSupport then python else null;
  inherit pythonSupport zlib;

  buildInputs =  if pythonSupport then [python] else [];
  propagatedBuildInputs = [zlib];
}
