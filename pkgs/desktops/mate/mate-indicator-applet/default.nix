{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, gtk3
, libayatana-indicator
, mate
, hicolor-icon-theme
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-indicator-applet";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "144fh9f3lag2cqnmb6zxlh8k83ya8kha6rmd7r8gg3z5w3nzpyz4";
  };

  postPatch = ''
    # Find installed Unity & Ayatana (new-style) indicators
    substituteInPlace src/applet-main.c \
      --replace '/usr/share' '/run/current-system/sw/share'
  '';

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libayatana-indicator
    mate.mate-panel
    hicolor-icon-theme
  ];

  configureFlags = [ "--with-ayatana-indicators" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
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
    maintainers = teams.mate.members;
  };
}
