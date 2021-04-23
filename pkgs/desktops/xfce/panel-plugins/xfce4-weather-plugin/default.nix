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
    sha256 = "1z2k24d599mxf5gqa35i3xmc3gk2yvqs80hxxpyw06yma6ljw973";
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

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-weather-plugin";
    description = "Weather plugin for the Xfce desktop environment";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
