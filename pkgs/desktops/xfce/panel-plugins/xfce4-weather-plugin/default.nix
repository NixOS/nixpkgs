{ lib
, stdenv
, fetchurl
, pkg-config
, intltool
, glib
, gtk3
, libxml2
, libsoup
, upower
, libxfce4ui
, libxfce4util
, xfce4-panel
, xfconf
, hicolor-icon-theme
, gitUpdater
}:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname = "xfce4-weather-plugin";
  version = "0.11.1";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-pFFG+aDc3JXRkcCcZK0nmuKJz4+BHEQz4I4xplaEUjk=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    glib
    gtk3
    libxml2
    libsoup
    upower
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
    hicolor-icon-theme
  ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/${pname}";
    rev-prefix = "${pname}-";
  };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-weather-plugin";
    description = "Weather plugin for the Xfce desktop environment";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
