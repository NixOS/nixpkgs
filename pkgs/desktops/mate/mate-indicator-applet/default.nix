{ stdenv, fetchurl, pkgconfig, gettext, gtk3, libindicator-gtk3, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-indicator-applet";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0m7pvbs5hhy5f400wqb8wp0dw3pyjpjnjax9qzc73j97l1k3zawf";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libindicator-gtk3
    mate.mate-panel
    hicolor-icon-theme
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/mate-desktop/mate-indicator-applet";
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
