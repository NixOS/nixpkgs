{
  stdenv,
  lib,
  fetchurl,
  gettext,
  pkg-config,
  glib,
  gtk3,
  libwnck,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  xfconf,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "xfce4-windowck-plugin";
  version = "0.5.2";

  src = fetchurl {
    # Use dist tarballs to avoid pulling extra deps and generating images ourselves.
    url = "mirror://xfce/src/panel-plugins/xfce4-windowck-plugin/${lib.versions.majorMinor version}/xfce4-windowck-plugin-${version}.tar.bz2";
    sha256 = "sha256-3E7V3JS9Bd5UlUQfDKuyYKs+H2ziex+skuN/kJwM/go=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
  ];

  buildInputs = [
    glib
    gtk3
    libwnck
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/xfce4-windowck-plugin";
    rev-prefix = "xfce4-windowck-plugin-";
  };

  meta = with lib; {
    description = "Xfce panel plugin for displaying window title and buttons";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-windowck-plugin";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
