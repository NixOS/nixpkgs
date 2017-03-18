{ stdenv, fetchurl, pkgs, pkgconfig, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name      = "mate-desktop-${version}";
  version   = "${major-ver}.${minor-ver}";
  major-ver = "1.17";
  minor-ver = "2";

  src = fetchurl {
    url    = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "1l7aih9hvmnmddwjwyafhz87drd5vdkmjr41m7f24bn5k7abl90g";
  };

  propagatedUserEnvPkgs = [ pkgs.gnome3.gnome_themes_standard ];

  buildInputs = with pkgs; [
      intltool
      pkgconfig

      gnome3.dconf
      gnome3.gtk
      gnome3.defaultIconTheme
  ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  meta = with stdenv.lib; {
    description = "Library with common API for various MATE modules";
    homepage    = "http://mate-desktop.org";
    license     = licenses.gpl2;
    platforms   = platforms.unix;
  };
}
