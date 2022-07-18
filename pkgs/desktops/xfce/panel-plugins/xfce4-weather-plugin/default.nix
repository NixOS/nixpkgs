{ lib, stdenv, fetchurl, pkg-config, intltool, libxml2, libsoup, upower,
  libxfce4ui, xfce4-panel, xfconf, hicolor-icon-theme, xfce }:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-weather-plugin";
  version = "0.11.0";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-4yQuqVHVG8D97R0CpPH2Yr7Bah+xDIVfcb2mVBoRU/w=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    libxml2
    libsoup
    upower
    libxfce4ui
    xfce4-panel
    xfconf
    hicolor-icon-theme
  ];

  enableParallelBuilding = true;

  passthru.updateScript = xfce.archiveUpdater { inherit category pname version; };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-weather-plugin";
    description = "Weather plugin for the Xfce desktop environment";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
