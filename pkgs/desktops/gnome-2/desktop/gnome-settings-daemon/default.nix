{ stdenv, fetchurl, pkgconfig, dbus_glib, libxklavier, gtk
, intltool, GConf, gnome_desktop, libglade, libgnomekbd, polkit, pulseaudio }:

stdenv.mkDerivation {
  name = "gnome-settings-daemon-2.32.1";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-settings-daemon/2.32/gnome-settings-daemon-2.32.1.tar.bz2;
    sha256 = "11jyn10w2p2a76pjrkd0pjl1w406df821p053awklvmdqgzb6x00";
  };

  buildInputs =
    [ dbus_glib libxklavier gtk GConf gnome_desktop libglade libgnomekbd polkit
      pulseaudio
    ];

  buildNativeInputs = [ pkgconfig intltool ];
}
