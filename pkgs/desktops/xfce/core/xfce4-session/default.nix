{ lib, mkXfceDerivation, polkit, exo, libxfce4util, libxfce4ui, xfconf, iceauth, gtk3, glib, libwnck, xfce4-session }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-session";
  version = "4.16.0";

  sha256 = "sha256-LIRAQ1YAkAHwIzC5NYV/0iFLkAP5V96wuTIrYTGbGy0=";

  buildInputs = [ exo gtk3 glib libxfce4ui libxfce4util libwnck xfconf polkit iceauth ];

  configureFlags = [ "--with-xsession-prefix=${placeholder "out"}" ];

  # See https://github.com/NixOS/nixpkgs/issues/36468
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  passthru.xinitrc = "${xfce4-session}/etc/xdg/xfce4/xinitrc";

  meta = with lib; {
    description = "Session manager for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
