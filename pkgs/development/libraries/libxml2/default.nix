{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true}:

assert zlib != null;
assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.6.27";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/GNOME/sources/libxml2/2.6/libxml2-2.6.27.tar.bz2;
    sha256 = "0kp0ghf5wgpv3ny6p4pvv38lj46ykbzsnpqpmv9irg4nidl72wl5";
  };

  python = if pythonSupport then python else null;
  inherit pythonSupport zlib;

  buildInputs =  if pythonSupport then [python] else [];
  propagatedBuildInputs = [zlib];
}
