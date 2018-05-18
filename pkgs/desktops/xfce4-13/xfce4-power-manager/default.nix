{ mkXfceDerivation, automakeAddFlags, exo, gtk3, libnotify
, libxfce4ui, libxfce4util, upower, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfce4-power-manager";
  version = "1.6.0";

  sha256 = "1sh6ydn44j1yki8f020ljayp1fjcigkywcvjp38fsk7j25ni2wrp";

  nativeBuildInputs = [ automakeAddFlags exo ];
  buildInputs = [ gtk3 libnotify libxfce4ui libxfce4util upower xfconf ];

  postPatch = ''
    substituteInPlace configure.ac.in --replace gio-2.0 gio-unix-2.0
    automakeAddFlags src/Makefile.am xfce4_power_manager_CFLAGS GIO_CFLAGS
    automakeAddFlags src/Makefile.am xfce4_power_manager_settings_CFLAGS GIO_CFLAGS
  '';
}
