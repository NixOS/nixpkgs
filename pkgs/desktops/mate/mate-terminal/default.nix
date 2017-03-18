{ stdenv, fetchurl, pkgs, pkgconfig, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name      = "mate-terminal-${version}";
  version   = "${major-ver}.${minor-ver}";
  major-ver = "1.17";
  minor-ver = "0";

  src = fetchurl {
    url    = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "0sbncykjf0ifj87rwpdw2ln0wavykiki4zqsw60vch7agh49fw0f";
  };

  buildInputs = with pkgs; [
     intltool
     pkgconfig
     glib
     itstool
     libxml2

     mate.mate-desktop

     gnome3.vte
     gnome3.gtk
     gnome3.dconf
  ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  meta = with stdenv.lib; {
    description = "The MATE Terminal Emulator";
    homepage    = "http://mate-desktop.org";
    license     = licenses.gpl3;
    platforms   = platforms.unix;
  };
}
