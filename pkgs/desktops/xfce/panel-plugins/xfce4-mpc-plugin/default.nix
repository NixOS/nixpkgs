{
  lib,
  stdenv,
  fetchurl,
  gettext,
  pkg-config,
  libxfce4util,
  xfce4-panel,
  libxfce4ui,
  glib,
  gtk3,
  gitUpdater,
}:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname = "xfce4-mpc-plugin";
  version = "0.5.5";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-TOfXdmeiY+6ZFsDKsqczsX471lcFzU7VzsPL3m5ymM8=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
  ];

  buildInputs = [
    libxfce4util
    libxfce4ui
    xfce4-panel
    glib
    gtk3
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/${pname}";
    rev-prefix = "${pname}-";
  };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-mpc-plugin";
    description = "MPD plugin for Xfce panel";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
