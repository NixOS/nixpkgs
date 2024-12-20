{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  xfce4-panel,
  libxfce4ui,
  xfconf,
  gitUpdater,
}:

let
  category = "panel-plugins";
in
stdenv.mkDerivation rec {
  pname = "xfce4-systemload-plugin";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-uzA/wwIOBTrR+guPy/DXaBxVY7uPZJNX1qlaV3gCsHI=";
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

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/${pname}";
    rev-prefix = "${pname}-";
  };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-systemload-plugin";
    description = "System load plugin for Xfce panel";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
