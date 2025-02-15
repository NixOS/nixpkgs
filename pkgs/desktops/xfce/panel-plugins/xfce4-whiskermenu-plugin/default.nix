{
  mkXfceDerivation,
  lib,
  fetchpatch,
  cmake,
  accountsservice,
  exo,
  garcon,
  gettext,
  glib,
  gtk-layer-shell,
  gtk3,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  xfconf,
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-whiskermenu-plugin";
  version = "2.9.1";
  rev-prefix = "v";
  odd-unstable = false;
  sha256 = "sha256-CHxKCH8FcikNzhI3rUU2IH0bTbBGqEz85f/ST8PSnSo=";

  patches = [
    # Fix menu not shown on correct monitor
    # https://gitlab.xfce.org/panel-plugins/xfce4-whiskermenu-plugin/-/issues/154
    (fetchpatch {
      url = "https://gitlab.xfce.org/panel-plugins/xfce4-whiskermenu-plugin/-/commit/e13216dcaa455e08368dcde256a6896d6e8918a1.patch";
      hash = "sha256-sRy1EgG8SaLgjdMH7XNSg97kj+tq2TI+G1P1d9aUXPc=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    accountsservice
    exo
    garcon
    gettext
    glib
    gtk-layer-shell
    gtk3
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  meta = with lib; {
    description = "Alternate application launcher for Xfce";
    mainProgram = "xfce4-popup-whiskermenu";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
