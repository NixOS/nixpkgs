{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libindicator-gtk3, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-indicator-applet-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0zad81qvcin4m329hfxhv4a5j8gf4gj8944mvjrdgdh71bzan2x1";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libindicator-gtk3
    mate.mate-panel
    hicolor-icon-theme
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
