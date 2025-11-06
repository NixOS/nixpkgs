{
  stdenv,
  mkXfceDerivation,
  lib,
  python3,
  vala,
  glib,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4util";
  version = "4.20.1";

  sha256 = "sha256-QlT5ev4NhjR/apbgYQsjrweJ2IqLySozLYLzCAnmkfM=";

  nativeBuildInputs = [
    python3
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala # vala bindings require GObject introspection
  ];

  propagatedBuildInputs = [
    glib
  ];

  postPatch = ''
    patchShebangs xdt-gen-visibility
  '';

  meta = with lib; {
    description = "Extension library for Xfce";
    mainProgram = "xfce4-kiosk-query";
    license = licenses.lgpl2Plus;
    teams = [ teams.xfce ];
  };
}
