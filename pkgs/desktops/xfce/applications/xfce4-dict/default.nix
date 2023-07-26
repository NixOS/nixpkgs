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
  version = "0.8.5";

  sha256 = "sha256-sU9V2cQUFG5571c7xrVSDCxanAbbnCUg2YLZ2uzoPJ0=";

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
