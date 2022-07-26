{ lib
, stdenv
, fetchurl
, pkg-config
, intltool
, libxfce4util
, xfce4-panel
, libxfce4ui
, gtk3
, xfce
}:

let
  category = "panel-plugins";
in stdenv.mkDerivation rec {
  pname  = "xfce4-genmon-plugin";
  version = "4.1.1";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-shGf0P8Z+ik7l+yXsN6OJBeZ4IuGIYUVFnxWi9m1ATU=";
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
  ];

  passthru.updateScript = xfce.archiveUpdater { inherit category pname version; };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-genmon-plugin";
    description = "Generic monitor plugin for the Xfce panel";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
