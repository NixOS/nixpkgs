{
  lib,
  stdenv,
  fetchurl,
  gettext,
  pkg-config,
  libxfce4util,
  xfce4-panel,
  libxfce4ui,
  glib,
  gtk3,
  hicolor-icon-theme,
  gitUpdater,
}:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname = "xfce4-timer-plugin";
  version = "1.7.3";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-rPTIYa+IYIuegCp2pLBYRr0wGJ4AhegmaAzBebbfTNM=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
  ];

  buildInputs = [
    libxfce4util
    libxfce4ui
    xfce4-panel
    glib
    gtk3
    hicolor-icon-theme
  ];

  hardeningDisable = [ "format" ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/${pname}";
    rev-prefix = "${pname}-";
  };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-timer-plugin";
    description = "Simple countdown and alarm plugin for the Xfce panel";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
