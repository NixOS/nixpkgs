{stdenv, fetchurl, pkgconfig, dbus, libgcrypt, libtasn1, pam, python, glib,
gtk, intltool, GConf, libgnome_keyring }:

stdenv.mkDerivation {
  name = "gnome-keyring-2.30.3";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-keyring/2.30/gnome-keyring-2.30.3.tar.bz2;
    sha256 = "02r9gv3a4a705jf3h7c0bizn33c73wz0iw2500m7z291nrnmqkmj";
  };
  
  buildInputs = [ dbus libgcrypt pam python gtk GConf libgnome_keyring ];

  propagatedBuildInputs = [ glib libtasn1 ];

  nativeBuildInputs = [ pkgconfig intltool ];
}
