{
  lib,
  mkXfceDerivation,
  fetchpatch,
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
  version = "4.20.2";

  sha256 = "sha256-wd+8W9Z0dH7bqILBUNG9YxpRf8TnRJ/7b3QviM1HVnY=";

  patches = [
    # Use syntax compatible with most sh shells
    # The `**` syntax is a bash extension
    (fetchpatch {
      url = "https://gitlab.xfce.org/xfce/xfce4-session/-/commit/53d6e20a29948ae7aa179447cef0704786b77f8b.patch";
      hash = "sha256-c8IU1VOcEYdZJy8Eq2wqSL5tTXt7gKfGOs7jxb8npOE=";
    })

    # wayland: start a D-Bus session only if there isn't one already
    # https://gitlab.xfce.org/xfce/xfce4-session/-/issues/218
    (fetchpatch {
      url = "https://gitlab.xfce.org/xfce/xfce4-session/-/commit/f6e2805b8a7742172f399d78618313bcb28bf095.patch";
      hash = "sha256-EViVialDbdLH2SGUtcroo5iGc+B4HVJajV7PMl5q6vs=";
    })
  ];

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
