{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true}:

assert zlib != null;
assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.6.17";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libxml2-2.6.17.tar.gz;
    md5 = "a678d37e68d98788ef51b6f913cdc868";
  };

  python = if pythonSupport then python else null;
  inherit pythonSupport;

  buildInputs =  if pythonSupport then [python] else [];
  propagatedBuildInputs = [zlib];
}
