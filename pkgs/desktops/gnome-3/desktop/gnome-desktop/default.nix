{ stdenv, fetchurl, pkgconfig, python, libxml2Python, libxslt, which, libX11, gnome3, gtk3, glib
, intltool, gnome_doc_utils, libxkbfile, xkeyboard_config, isocodes, itstool, wayland
, gobjectIntrospection }:

stdenv.mkDerivation rec {

  majorVersion = "3.10";
  minorVersion = "1";
  name = "gnome-desktop-${majorVersion}.${minorVersion}";

  # this should probably be setuphook for glib
  NIX_CFLAGS_COMPILE = "-I${glib}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-desktop/${majorVersion}/${name}.tar.xz";
    sha256 = "0hdvm909lbpnixqv11qdx9iaycx4dpxys46fa128bqp8alisgb0h";
  };

  buildInputs = [ pkgconfig python libxml2Python libxslt which libX11 xkeyboard_config isocodes itstool wayland
                  gtk3 glib intltool gnome_doc_utils libxkbfile gnome3.gsettings_desktop_schemas gobjectIntrospection ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
