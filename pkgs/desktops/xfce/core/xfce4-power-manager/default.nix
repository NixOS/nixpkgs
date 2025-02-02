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

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-power-manager";
  version = "4.18.3";

  sha256 = "sha256-CuW2siApho7u8P01t15dAiqNAiwQzAMZsEugYuKN4kM=";

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
  '';

  meta = with lib; {
    description = "Power manager for the Xfce Desktop Environment";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
