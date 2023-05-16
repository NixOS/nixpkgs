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
<<<<<<< HEAD
  version = "0.13.1";
  odd-unstable = false;

  sha256 = "sha256-Tor4mA0uSpVCdK6mla1L0JswgURnGPOfkYBR2N1AbL0=";
=======
  version = "0.13.0";
  odd-unstable = false;

  sha256 = "sha256-K1cC5NnRv/C5ZiwMAmaQ8qxvlxHRsJ4F1TgR9CN8Qgc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
