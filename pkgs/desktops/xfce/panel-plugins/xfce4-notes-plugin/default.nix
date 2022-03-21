{ lib
, stdenv
, fetchurl
, pkg-config
, intltool
, xfce4-panel
, libxfce4ui
, xfconf
, xfce
}:

let
  category = "panel-plugins";
in stdenv.mkDerivation rec {
  pname  = "xfce4-notes-plugin";
  version = "1.9.0";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-E/kJyUi2Oflt5kz3k+t0yxd5WJIB05M+/yFO6PNasIg=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    libxfce4ui
    xfce4-panel
    xfconf
  ];

  passthru.updateScript = xfce.archiveUpdater { inherit category pname version; };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-notes-plugin";
    description = "Sticky notes plugin for Xfce panel";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
