{
  lib,
  mkXfceDerivation,
  thunar,
  exo,
  libxfce4util,
  gtk3,
  glib,
  subversion,
  apr,
  aprutil,
  withSubversion ? false,
}:
mkXfceDerivation {
  category = "thunar-plugins";
  pname = "thunar-vcs-plugin";
  version = "0.3.0";
  odd-unstable = false;

  sha256 = "sha256-e9t6lIsvaV/2AAL/7I4Pbcokvy7Lp2+D9sJefTZqB1g=";

  buildInputs =
    [
      thunar
      exo
      libxfce4util
      gtk3
      glib
    ]
    ++ lib.optionals withSubversion [
      apr
      aprutil
      subversion
    ];

  meta = {
    description = "Thunar plugin providing support for Subversion and Git";
    maintainers = with lib.maintainers; [ lordmzte ] ++ lib.teams.xfce.members;
  };
}
