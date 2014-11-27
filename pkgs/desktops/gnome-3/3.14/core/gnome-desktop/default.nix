{ stdenv, fetchurl, pkgconfig, python, libxml2Python, libxslt, which, libX11, gnome3, gtk3, glib
, intltool, gnome_doc_utils, libxkbfile, xkeyboard_config, isocodes, itstool, wayland
, gobjectIntrospection }:

stdenv.mkDerivation rec {

  majorVersion = gnome3.version;
  minorVersion = "2";
  name = "gnome-desktop-${majorVersion}.${minorVersion}";

  # this should probably be setuphook for glib
  NIX_CFLAGS_COMPILE = "-I${glib}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-desktop/${majorVersion}/${name}.tar.xz";
    sha256 = "3c284378fd4d5c9aba1ef98b8bab78d0f7fe514964f9dfcfc3b1591328d6b873";
  };

  buildInputs = [ pkgconfig python libxml2Python libxslt which libX11 xkeyboard_config isocodes itstool wayland
                  gtk3 glib intltool gnome_doc_utils libxkbfile gnome3.gsettings_desktop_schemas gobjectIntrospection ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
