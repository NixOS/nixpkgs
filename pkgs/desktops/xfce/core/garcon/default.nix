{
  stdenv,
  lib,
  mkXfceDerivation,
  gtk3,
  libxfce4ui,
  libxfce4util,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "garcon";
  version = "4.20.0";

  sha256 = "sha256-MeZkDb2QgGMaloO6Nwlj9JmZByepd6ERqpAWqrVv1xw=";

  nativeBuildInputs = lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libxfce4ui
    libxfce4util
  ];

  meta = with lib; {
    description = "Xfce menu support library";
    license = with licenses; [
      lgpl2Only
      fdl11Only
    ];
    teams = [ teams.xfce ];
  };
}
