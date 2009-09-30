{ stdenv, fetchurl, pkgconfig, dbus_glib, libxklavier, gtk
, intltool, GConf, gnome_desktop, libglade, libgnomekbd}:

stdenv.mkDerivation {
  name = "gnome-settings-daemon-2.28.0";
  src = fetchurl {
    url = mirror://gnome/sources/gnome-settings-daemon/2.28/gnome-settings-daemon-2.28.0.tar.bz2;
    sha256 = "1md46vs3m36czwjdkz084facanjr03cxgr50frf2yln60kc06cnz";
  };
  buildInputs = [ pkgconfig intltool dbus_glib libxklavier gtk GConf gnome_desktop libglade libgnomekbd ];
}
