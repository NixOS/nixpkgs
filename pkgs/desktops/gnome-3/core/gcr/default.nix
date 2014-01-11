{ stdenv, fetchurl, pkgconfig, intltool, gnupg, p11_kit, glib
, libgcrypt, libtasn1, dbus_glib, gtk, pango, gdk_pixbuf, atk }:

stdenv.mkDerivation rec {
  name = "gcr-3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gcr/3.10/${name}.tar.xz";
    sha256 = "0nv470a8cvw4rw49hf5aqvll1rpkacmsr3pj8s1l205yaid4yvq0";
  };

  buildInputs = [
    pkgconfig intltool gnupg p11_kit glib
    libgcrypt libtasn1 dbus_glib gtk pango gdk_pixbuf atk
  ];

  configureFlags = [ "--disable-introspection" ];

  #doCheck = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
