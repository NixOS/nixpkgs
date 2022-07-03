{ lib, stdenv, fetchurl, pkg-config, intltool, libxfce4util, xfce4-panel, libxfce4ui, gtk3, hicolor-icon-theme, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-timer-plugin";
  version = "1.7.1";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-S1LSkRsZSelFlxvmUzFV7mupnHcHjqx/1DsPKuyoJOM=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    libxfce4util
    libxfce4ui
    xfce4-panel
    gtk3
    hicolor-icon-theme
  ];

  hardeningDisable = [ "format" ];

  passthru.updateScript = xfce.archiveUpdater { inherit category pname version; };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-timer-plugin";
    description = "Simple countdown and alarm plugin for the Xfce panel";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
