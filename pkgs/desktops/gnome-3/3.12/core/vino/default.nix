{ stdenv, intltool, fetchurl, gtk3, glib, libsoup, pkgconfig, makeWrapper
, hicolor_icon_theme, gnome3
, libnotify, file, telepathy_glib, dbus_glib }:

stdenv.mkDerivation rec {
  name = "vino-${versionMajor}.${versionMinor}";
  versionMajor = "3.12";
  versionMinor = "0";

  src = fetchurl {
    url = "mirror://gnome/sources/vino/${versionMajor}/${name}.tar.xz";
    sha256 = "86c9d8b60d79982e4488815db0d441c398e011ad8262659789afecc97a01ca5b";
  };

  doCheck = true;

  buildInputs = [ gtk3 intltool glib libsoup pkgconfig libnotify
                  hicolor_icon_theme gnome3.gnome_icon_theme gnome3.gnome_icon_theme_symbolic
                  dbus_glib telepathy_glib file makeWrapper ];

  preFixup = ''
    wrapProgram "$out/libexec/vino-server" \
      --prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Projects/Vino;
    description = "GNOME desktop sharing server";
    maintainers = with maintainers; [ lethalman iElectric ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
