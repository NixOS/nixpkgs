{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true}:

assert zlib != null;
assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.6.13";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libxml2-2.6.13.tar.gz;
    md5 = "23e9a2cfcd700fd4ff70996fd7c632c0";
  };

  python = if pythonSupport then python else null;
  inherit pythonSupport;

  buildInputs =  if pythonSupport then [python] else [];
  propagatedBuildInputs = [zlib];
}
