{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, flex, bison, libxml2, intltool,
  itstool, python, makeWrapper }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig flex bison gtk3 libxml2 gnome3.gjs gnome3.gdl
    gnome3.libgda gnome3.gtksourceview intltool itstool python makeWrapper ];

  preFixup = ''
    wrapProgram $out/bin/anjuta \
      --prefix XDG_DATA_DIRS : \
        "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Software development studio";
    homepage = http://anjuta.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
