{
  lib,
  stdenv,
  fetchurl,
  gettext,
  pkg-config,
  libxfce4util,
  xfce4-panel,
  xfconf,
  libxfce4ui,
  gtk3,
  gitUpdater,
}:

let
  category = "panel-plugins";
in
stdenv.mkDerivation rec {
  pname = "xfce4-genmon-plugin";
  version = "4.2.1";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-3lQFYuHqWPNanIFeIHNtJq9UGgqTcgERSMt1tfC2WVE=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
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
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-genmon-plugin";
    description = "Generic monitor plugin for the Xfce panel";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
