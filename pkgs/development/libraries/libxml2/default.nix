{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true}:

assert zlib != null;
assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.6.8";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/GNOME/sources/libxml2/2.6/libxml2-2.6.8.tar.bz2;
    md5 = "f8a0dc1983f67db388baa0f7c65d2b70";
  };

  python = if pythonSupport then python else null;
  inherit pythonSupport;

  buildInputs =  if pythonSupport then [python] else [];
  propagatedBuildInputs = [zlib];
}
