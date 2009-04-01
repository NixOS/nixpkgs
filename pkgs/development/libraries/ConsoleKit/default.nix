{stdenv, fetchurl, pkgconfig, dbus_glib, zlib, pam, glib, libX11}:

stdenv.mkDerivation {
  name = "ConsoleKit-0.3.0";
  src = fetchurl {
    url = http://people.freedesktop.org/~mccann/dist/ConsoleKit-0.3.0.tar.bz2;
    md5 = "43b02a52212330b54cfb34c4044d9ce0";    
  };
  buildInputs = [ pkgconfig dbus_glib zlib pam glib libX11 ];
}
