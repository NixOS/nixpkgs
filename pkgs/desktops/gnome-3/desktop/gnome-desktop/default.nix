{ stdenv, fetchurl, pkgconfig, python, libxml2Python, libxslt, which, libX11, gnome3, gtk3, glib
, intltool, gnome_doc_utils, libxkbfile, xkeyboard_config, isocodes, itstool, wayland
, gobjectIntrospection }:

stdenv.mkDerivation rec {

  majorVersion = "3.11";
  minorVersion = "2";
  name = "gnome-desktop-${majorVersion}.${minorVersion}";

  # this should probably be setuphook for glib
  NIX_CFLAGS_COMPILE = "-I${glib}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-desktop/${majorVersion}/${name}.tar.xz";
    sha256 = "0vsxgp77s0pmcq177lz310ync4c1n7cwb63163zm5g5xw69qc5d7";
  };

  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ pkgconfig python libxml2Python libxslt which libX11 xkeyboard_config isocodes itstool wayland
                  gtk3 glib intltool gnome_doc_utils libxkbfile gnome3.gsettings_desktop_schemas gobjectIntrospection ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
