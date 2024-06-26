{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  libxfce4util,
  xfce4-panel,
  libxfce4ui,
  xfconf,
  glib,
  gtk3,
  gitUpdater,
}:

let
  category = "panel-plugins";
in
stdenv.mkDerivation rec {
  pname = "xfce4-fsguard-plugin";
  version = "1.1.3";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-hO+LtHUiktZMDvEBut97FESHkL+gqF3mRNv6Iphuwlg=";
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
    glib
    gtk3
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/${pname}";
    rev-prefix = "${pname}-";
  };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-fsguard-plugin";
    description = "Filesystem usage monitor plugin for the Xfce panel";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
