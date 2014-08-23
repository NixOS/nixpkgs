{ stdenv, fetchurl, pkgconfig, autoreconfHook, glib, gettext, gnome_common, gtk3, dbus_glib
, upower, json_glib,intltool, systemd, hicolor_icon_theme, xorg, makeWrapper, cinnamon-desktop }:

let
  version = "2.0.6";
in
stdenv.mkDerivation {
  name = "cinnamon-session-${version}";

  src = fetchurl {
    url = "http://github.com/linuxmint/cinnamon-session/archive/${version}.tar.gz";
    sha256 = "0rs5w7npj3wf3gkk3sfb83awks2h7vjd6cz8mvfgbh6m3grn66l3";
  };


  configureFlags = "--enable-systemd --disable-gconf" ;

  patches = [ ./remove-sessionmigration.patch ./timeout.patch];

  buildInputs = [
    pkgconfig autoreconfHook
    glib gettext gnome_common
    gtk3 dbus_glib upower json_glib
    intltool systemd xorg.xtrans
    makeWrapper
    cinnamon-desktop /*gschemas*/
   ];

  preBuild = "patchShebangs ./scripts";


  postFixup  = ''
    rm $out/share/icons/hicolor/icon-theme.cache

    for f in "$out/bin/"*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "The cinnamon session files" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.roelof ];

    broken = true;
  };
}
