{ lib
, mkXfceDerivation
, automakeAddFlags
, glib
, gtk3
, libxfce4ui
, libxfce4util
, xfce4-panel
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-dict";
  version = "0.8.6";

  sha256 = "sha256-a7St9iH+jzwq/llrMJkuqwgQrDFEjqebs/N6Lxa3dkI=";

  patches = [ ./configure-gio.patch ];

  nativeBuildInputs = [ automakeAddFlags ];

  postPatch = ''
    automakeAddFlags lib/Makefile.am libdict_la_CFLAGS GIO_CFLAGS
  '';

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    libxfce4util
    xfce4-panel
  ];

  meta = with lib; {
    description = "A Dictionary Client for the Xfce desktop environment";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
