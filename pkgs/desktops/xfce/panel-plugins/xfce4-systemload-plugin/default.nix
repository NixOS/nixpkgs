{
  lib,
  stdenv,
  fetchurl,
  gettext,
  pkg-config,
  xfce4-panel,
  libgtop,
  libxfce4ui,
  upower,
  xfconf,
  gitUpdater,
}:

let
  category = "panel-plugins";
in
stdenv.mkDerivation rec {
  pname = "xfce4-systemload-plugin";
  version = "1.3.3";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-aFLV2cmnTQ4NtYLG9f5zkOvkii61aSF3rhLhxMzG78k=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
  ];

  buildInputs = [
    libgtop
    libxfce4ui
    upower
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
