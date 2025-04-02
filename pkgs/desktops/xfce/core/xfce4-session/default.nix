{
  lib,
  mkXfceDerivation,
  polkit,
  exo,
  libxfce4util,
  libxfce4ui,
  xfconf,
  iceauth,
  gtk3,
  glib,
  libwnck,
  xfce4-session,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-session";
  version = "4.18.4";

  sha256 = "sha256-YxIHxb8mRggHLJ9TQ+KGb9qjt+DMZrxMn+oFuFRL8GI=";

  buildInputs = [
    exo
    gtk3
    glib
    libxfce4ui
    libxfce4util
    libwnck
    xfconf
    polkit
    iceauth
  ];

  configureFlags = [ "--with-xsession-prefix=${placeholder "out"}" ];

  passthru.xinitrc = "${xfce4-session}/etc/xdg/xfce4/xinitrc";

  meta = with lib; {
    description = "Session manager for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
