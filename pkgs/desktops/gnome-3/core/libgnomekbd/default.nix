{ stdenv, fetchurl, pkgconfig, file, intltool, glib, gtk3, libxklavier, makeWrapper, gnome3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ file intltool glib gtk3 libxklavier makeWrapper ];

  preFixup = ''
    wrapProgram $out/bin/gkbd-keyboard-display \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Keyboard management library";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
