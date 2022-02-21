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
, xfce
}:

let
  category = "panel-plugins";
in stdenv.mkDerivation rec {
  pname  = "xfce4-eyes-plugin";
  version = "4.5.1";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-TbeAF45Sk5HVPaGA5JOGkE5ppaM7O9UYWDXQp+b/WsU=";
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

  passthru.updateScript = xfce.archiveUpdater { inherit category pname version; };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-eyes-plugin";
    description = "Rolling eyes (following mouse pointer) plugin for the Xfce panel";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
