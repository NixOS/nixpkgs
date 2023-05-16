<<<<<<< HEAD
{ lib
, mkXfceDerivation
, gtk3
, libnotify
, libxfce4ui
, libxfce4util
, upower
, xfconf
, xfce4-panel
}:
=======
{ lib, mkXfceDerivation, automakeAddFlags, exo, gtk3, libnotify
, libxfce4ui, libxfce4util, upower, xfconf, xfce4-panel }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-power-manager";
<<<<<<< HEAD
  version = "4.18.2";

  sha256 = "sha256-1+DP5CACzzj96FyRTeCdVEFORnpzFT49d9Uk1iijbFs=";

  buildInputs = [
    gtk3
    libnotify
    libxfce4ui
    libxfce4util
    upower
    xfconf
    xfce4-panel
  ];

  # using /run/current-system/sw/bin instead of nix store path prevents polkit permission errors on
  # rebuild.  See https://github.com/NixOS/nixpkgs/issues/77485
  postPatch = ''
    substituteInPlace src/org.xfce.power.policy.in2 --replace "@sbindir@" "/run/current-system/sw/bin"
    substituteInPlace common/xfpm-brightness.c --replace "SBINDIR" "\"/run/current-system/sw/bin\""
    substituteInPlace src/xfpm-suspend.c --replace "SBINDIR" "\"/run/current-system/sw/bin\""
=======
  version = "4.18.1";

  sha256 = "sha256-H9tu94ZQLLQhXIDtIWL3qZJo/ux2xC2Y9m7uwwey8M8=";

  nativeBuildInputs = [ automakeAddFlags exo ];
  buildInputs = [ gtk3 libnotify libxfce4ui libxfce4util upower xfconf xfce4-panel ];

  postPatch = ''
    substituteInPlace configure.ac.in --replace gio-2.0 gio-unix-2.0
    automakeAddFlags src/Makefile.am xfce4_power_manager_CFLAGS GIO_CFLAGS
    automakeAddFlags settings/Makefile.am xfce4_power_manager_settings_CFLAGS GIO_CFLAGS
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "A power manager for the Xfce Desktop Environment";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
