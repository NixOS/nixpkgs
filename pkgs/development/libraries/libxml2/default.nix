{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true}:

assert zlib != null;
assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.6.29";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxml2-2.6.29.tar.gz;
    sha256 = "14jrjvdbvlbc3m0q9p3np67sk18w317n5zfg9a3h7b6pp7h1jjp3";
  };

  python = if pythonSupport then python else null;
  inherit pythonSupport zlib;

  buildInputs =  if pythonSupport then [python] else [];
  propagatedBuildInputs = [zlib];
}
