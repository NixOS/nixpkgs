{ mkXfceDerivation, polkit, exo, libxfce4util, libxfce4ui, xfconf, iceauth, gtk3, glib, libwnck3, xorg, xfce4-session }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-session";
  version = "4.14.0";

  sha256 = "0v0xzkdr5rgv6219c1dy96cghgw8bqnb313jccxihfgddf363104";

  buildInputs = [ exo gtk3 glib libxfce4ui libxfce4util libwnck3 xfconf polkit iceauth ];

  configureFlags = [ "--with-xsession-prefix=${placeholder "out"}" ];

  # See https://github.com/NixOS/nixpkgs/issues/36468
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  passthru.xinitrc = "${xfce4-session}/etc/xdg/xfce4/xinitrc";

  meta =  {
    description = "Session manager for Xfce";
  };
}
