{ stdenv, fetchurl, pkgconfig, dbus_glib, libxklavier, gtk
, intltool, GConf, gnome_desktop, libglade, libgnomekbd}:

stdenv.mkDerivation {
  name = "gnome-settings-daemon-2.26.1";
  src = fetchurl {
    url = mirror://gnome/desktop/2.26/2.26.2/sources/gnome-settings-daemon-2.26.1.tar.bz2;
    sha256 = "100ax9dfcd0wzfsdv4p75qq950hqvpqnsa315wq5wj7yhjm1vzsd";
  };
  buildInputs = [ pkgconfig intltool dbus_glib libxklavier gtk GConf gnome_desktop libglade libgnomekbd ];
}
