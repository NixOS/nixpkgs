{
  lib,
  mkXfceDerivation,
  polkit,
  exo,
  libxfce4util,
  libxfce4ui,
  libxfce4windowing,
  xfconf,
  iceauth,
  gtk3,
  gtk-layer-shell,
  glib,
  libwnck,
  xfce4-session,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-session";
  version = "4.20.3";

  sha256 = "sha256-HfVspmAkjuGgoI87VHNHFGZP17ZA0b31llY93gUtWxs=";

  buildInputs = [
    exo
    gtk3
    gtk-layer-shell
    glib
    libxfce4ui
    libxfce4util
    libxfce4windowing
    libwnck
    xfconf
    polkit
    iceauth
  ];

  configureFlags = [
    "--with-xsession-prefix=${placeholder "out"}"
    "--with-wayland-session-prefix=${placeholder "out"}"
  ];

  passthru.xinitrc = "${xfce4-session}/etc/xdg/xfce4/xinitrc";

  meta = with lib; {
    description = "Session manager for Xfce";
    teams = [ teams.xfce ];
  };
}
