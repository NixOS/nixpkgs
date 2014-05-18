{ fetchurl, stdenv, pkgconfig, gnome3, intltool, glib, libnotify, lcms2, libXtst
, libxkbfile, pulseaudio, libcanberra_gtk3, upower, colord, libgweather, polkit
, geoclue2, librsvg, xf86_input_wacom, udev, libwacom, libxslt, libtool
, docbook_xsl, docbook_xsl_ns, makeWrapper, ibus }:

stdenv.mkDerivation rec {
  name = "gnome-settings-daemon-3.10.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/3.10/${name}.tar.xz";
    sha256 = "0r42lzlgk0w40ws4d3s7yayn6n8zqlnh5b6k88gvgv1lwk39k240";
  };

  # fatal error: gio/gunixfdlist.h: No such file or directory
  NIX_CFLAGS_COMPILE = "-I${glib}/include/gio-unix-2.0";

  buildInputs = with gnome3;
    [ intltool pkgconfig ibus gtk glib gsettings_desktop_schemas libnotify gnome_desktop
      lcms2 libXtst libxkbfile pulseaudio libcanberra_gtk3 upower colord libgweather
      polkit geocode_glib geoclue2 librsvg xf86_input_wacom udev libwacom libxslt
      libtool docbook_xsl docbook_xsl_ns makeWrapper gnome_themes_standard ];

  preFixup = ''
    wrapProgram "$out/libexec/gnome-settings-daemon-localeexec" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix PATH : "${glib}/bin" \
      --prefix XDG_DATA_DIRS : "${gnome3.gtk}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
