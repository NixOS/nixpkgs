{ mkXfceDerivation, automakeAddFlags, exo, gtk3, libnotify
, libxfce4ui, libxfce4util, upower, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfce4-power-manager";
  version = "1.6.5";

  sha256 = "0zazm2cgkz5xj7rvy9gbh4kaay2anfcmawg4gj38pnq3a8zcwwd5";

  nativeBuildInputs = [ automakeAddFlags exo ];
  buildInputs = [ gtk3 libnotify libxfce4ui libxfce4util upower xfconf ];

  postPatch = ''
    substituteInPlace configure.ac.in --replace gio-2.0 gio-unix-2.0
    automakeAddFlags src/Makefile.am xfce4_power_manager_CFLAGS GIO_CFLAGS
    automakeAddFlags settings/Makefile.am xfce4_power_manager_settings_CFLAGS GIO_CFLAGS
  '';
}
