{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libindicator-gtk3, mate-panel, hicolor_icon_theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-indicator-applet-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "1h77f1gbz1a8l9xyq5fk75bs58mcwx6pbk6db33v0v1mwq6cidiv";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libindicator-gtk3
    mate-panel
    hicolor_icon_theme
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mate-desktop/mate-indicator-applet;
    description = "MATE panel indicator applet";
    longDescription = ''
      A small applet to display information from various applications
      consistently in the panel.
       
      The indicator applet exposes Ayatana Indicators in the MATE Panel.
      Ayatana Indicators are an initiative by Canonical to provide crisp and
      clean system and application status indication. They take the form of
      an icon and associated menu, displayed (usually) in the desktop panel.
      Existing indicators include the Message Menu, Battery Menu and Sound
      menu.
    '';
    license = with licenses; [ gpl3Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
