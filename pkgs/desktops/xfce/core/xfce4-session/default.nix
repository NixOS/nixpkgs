{ lib
, mkXfceDerivation
, fetchpatch
, polkit
, exo
, libxfce4util
, libxfce4ui
, xfconf
, iceauth
, gtk3
, glib
, libwnck
, xfce4-session
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-session";
  version = "4.18.3";

  sha256 = "sha256-qCkE3aVYVwphoO1ZAyzpL1ZtsLaP6XT1H1rlFoBI3yg=";

  patches = [
    # Add minimal xdg-desktop-portal conf file
    # https://gitlab.xfce.org/xfce/xfce4-session/-/issues/181
    (fetchpatch {
      url = "https://gitlab.xfce.org/xfce/xfce4-session/-/commit/6451c8b21085631d8861e07ff4e1b2ef64a64ad3.patch";
      sha256 = "sha256-t3opom0iv7QsKoivzk+nXbxI5uFhNmB8/Qwb4QHvcCQ=";
    })
  ];

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

  # See https://github.com/NixOS/nixpkgs/issues/36468
  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  passthru.xinitrc = "${xfce4-session}/etc/xdg/xfce4/xinitrc";

  meta = with lib; {
    description = "Session manager for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
