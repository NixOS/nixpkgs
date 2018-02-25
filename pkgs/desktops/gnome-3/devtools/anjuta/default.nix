{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, flex, bison, libxml2, intltool,
  itstool, python3, ncurses, makeWrapper }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkgconfig intltool itstool python3 makeWrapper
    # Required by python3
    ncurses
  ];
  buildInputs = [
    flex bison gtk3 libxml2 gnome3.gjs gnome3.gdl
    gnome3.libgda gnome3.gtksourceview
    gnome3.gsettings-desktop-schemas
  ];

  preFixup = ''
    wrapProgram $out/bin/anjuta \
      --prefix XDG_DATA_DIRS : \
        "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Software development studio";
    homepage = http://anjuta.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
