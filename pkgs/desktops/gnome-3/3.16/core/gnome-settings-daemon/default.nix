{ fetchurl, stdenv, pkgconfig, gnome3, intltool, glib, libnotify, lcms2, libXtst
, libxkbfile, libpulseaudio, libcanberra_gtk3, upower, colord, libgweather, polkit
, geoclue2, librsvg, xf86_input_wacom, udev, libwacom, libxslt, libtool, networkmanager
, docbook_xsl, docbook_xsl_ns, makeWrapper, ibus, xkeyboard_config }:

stdenv.mkDerivation rec {
  name = "gnome-settings-daemon-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${gnome3.version}/${name}.tar.xz";
    sha256 = "1l61h497v57g3iqfmyzjh15z4c4akky3xziymphswzigb1ssv3da";
  };

  # fatal error: gio/gunixfdlist.h: No such file or directory
  NIX_CFLAGS_COMPILE = "-I${glib}/include/gio-unix-2.0";

  buildInputs = with gnome3;
    [ intltool pkgconfig ibus gtk glib gsettings_desktop_schemas networkmanager
      libnotify gnome_desktop lcms2 libXtst libxkbfile libpulseaudio
      libcanberra_gtk3 upower colord libgweather xkeyboard_config
      polkit geocode_glib geoclue2 librsvg xf86_input_wacom udev libwacom libxslt
      libtool docbook_xsl docbook_xsl_ns makeWrapper gnome_themes_standard ];

  preFixup = ''
    wrapProgram "$out/libexec/gnome-settings-daemon-localeexec" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix PATH : "${glib}/bin" \
      --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };

}
