{ mkXfceDerivation, automakeAddFlags, exo, gtk3, libnotify
, libxfce4ui, libxfce4util, upower, xfconf, xfce4-panel }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-power-manager";
  version = "4.16.0";

  sha256 = "sha256-Qk++1db+agiU99p+QW8/WNnNqFVejV/BcnmgvfoB3OU=";

  nativeBuildInputs = [ automakeAddFlags exo ];
  buildInputs = [ gtk3 libnotify libxfce4ui libxfce4util upower xfconf xfce4-panel ];

  postPatch = ''
    substituteInPlace configure.ac.in --replace gio-2.0 gio-unix-2.0
    automakeAddFlags src/Makefile.am xfce4_power_manager_CFLAGS GIO_CFLAGS
    automakeAddFlags settings/Makefile.am xfce4_power_manager_settings_CFLAGS GIO_CFLAGS
  '';

  meta = {
    description = "A power manager for the Xfce Desktop Environment";
  };
}
