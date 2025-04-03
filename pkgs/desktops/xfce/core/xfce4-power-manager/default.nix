{
  lib,
  mkXfceDerivation,
  gtk3,
  libnotify,
  libxfce4ui,
  libxfce4util,
  upower,
  xfconf,
  xfce4-panel,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-power-manager";
  version = "4.18.4";

  sha256 = "sha256-aybY+B8VC/XS6FO3XRpYuJd9Atr9Tc/Uo45q9fh3YLE=";

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
    substituteInPlace src/org.xfce.power.policy.in2 --replace-fail "@sbindir@" "/run/current-system/sw/bin"
    substituteInPlace common/xfpm-brightness.c --replace-fail "SBINDIR" "\"/run/current-system/sw/bin\""
    substituteInPlace src/xfpm-suspend.c --replace-fail "SBINDIR" "\"/run/current-system/sw/bin\""
  '';

  meta = with lib; {
    description = "Power manager for the Xfce Desktop Environment";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
