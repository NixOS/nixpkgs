{stdenv, fetchurl, pkgconfig, dbus, libgcrypt, libtasn1, pam, hal, python, glib, gtk, intltool, GConf}:

stdenv.mkDerivation {
  name = "gnome-keyring-2.26.1";
  src = fetchurl {
    url = mirror://gnome/desktop/2.26/2.26.2/sources/gnome-keyring-2.26.1.tar.bz2;
    sha256 = "09krpx4nrcrf0ghvfcpg3gxnna6a97drya36ypcijb35cdwrm9s7";
  };
  buildInputs = [ pkgconfig dbus.libs libgcrypt libtasn1 pam hal python glib gtk intltool GConf ];
}
