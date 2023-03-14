{ lib
, stdenv
, fetchurl
, pkg-config
, intltool
, libxfce4util
, xfce4-panel
, libxfce4ui
, xfconf
, gtk3
, gitUpdater
}:

let
  category = "panel-plugins";
in stdenv.mkDerivation rec {
  pname  = "xfce4-eyes-plugin";
  version = "4.6.0";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-rQ/wXYi6OTt8iSL4Iz7dM/wKTosAC2HeH486EMWuUyQ=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    libxfce4util
    libxfce4ui
    xfce4-panel
    xfconf
    gtk3
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/${pname}";
    rev-prefix = "${pname}-";
  };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-eyes-plugin";
    description = "Rolling eyes (following mouse pointer) plugin for the Xfce panel";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
