{stdenv, fetchurl, pkgconfig, dbus, libgcrypt, libtasn1, pam, hal, python, glib, gtk, intltool, GConf}:

stdenv.mkDerivation {
  name = "gnome-keyring-2.28.0";
  src = fetchurl {
    url = mirror:/gnome/sources/gnome-keyring/2.28/gnome-keyring-2.28.0.tar.bz2;
    sha256 = "1d6av3cq32ypq9f9mv7f9bcqkkdqgbvbb831kad62smczvqk8chv"
  };
  buildInputs = [ pkgconfig dbus.libs libgcrypt libtasn1 pam hal python glib gtk intltool GConf ];
}
