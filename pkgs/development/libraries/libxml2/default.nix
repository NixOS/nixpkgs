{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true}:

assert zlib != null;
assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.6.22";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libxml2-2.6.22.tar.gz;
    md5 = "1db8d06b4f49a665a8f47dc6d94450e6";
  };

  python = if pythonSupport then python else null;
  inherit pythonSupport;

  buildInputs =  if pythonSupport then [python] else [];
  propagatedBuildInputs = [zlib];
}
