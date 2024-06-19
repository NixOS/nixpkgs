{ lib
, mkXfceDerivation
, gtk3
, glib
, libexif
, libxfce4ui
, libxfce4util
, xfconf
}:

mkXfceDerivation {
  category = "apps";
  pname = "ristretto";
  version = "0.13.2";
  odd-unstable = false;

  sha256 = "sha256-FKgNKQ2l4FGvEvmppf+RTxMXU6TfsZVFBVii4zr4ASc=";

  buildInputs = [
    glib
    gtk3
    libexif
    libxfce4ui
    libxfce4util
    xfconf
  ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = with lib; {
    description = "A fast and lightweight picture-viewer for the Xfce desktop environment";
    mainProgram = "ristretto";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
