{
  lib,
  stdenv,
  fetchurl,
  gettext,
  pkg-config,
  xfce4-panel,
  libxfce4ui,
  libxfce4util,
  exo,
  glib,
  gtk3,
  gnutls,
  libgcrypt,
  gitUpdater,
}:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname = "xfce4-mailwatch-plugin";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-xHg/FTOJHNLgw0Bm2oWYZNzkWiPKpgFbWMufqdZafkQ=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
  ];

  buildInputs = [
    libxfce4ui
    libxfce4util
    xfce4-panel
    exo
    glib
    gtk3
    gnutls
    libgcrypt
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/${pname}";
    rev-prefix = "${pname}-";
  };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-mailwatch-plugin";
    description = "Mail watcher plugin for Xfce panel";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
