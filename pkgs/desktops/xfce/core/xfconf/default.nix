{
  stdenv,
  lib,
  mkXfceDerivation,
  gobject-introspection,
  perl,
  vala,
  libxfce4util,
  glib,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfconf";
  version = "4.20.0";

  sha256 = "sha256-U+Sk7ubBr1ZD1GLQXlxrx0NQdhV/WpVBbnLcc94Tjcw=";

  nativeBuildInputs = [
    perl
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala # vala bindings require GObject introspection
  ];

  buildInputs = [ libxfce4util ];

  propagatedBuildInputs = [ glib ];

  meta = with lib; {
    description = "Simple client-server configuration storage and query system for Xfce";
    mainProgram = "xfconf-query";
    teams = [ teams.xfce ];
  };
}
