{
  stdenv,
  mkXfceDerivation,
  lib,
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
  version = "4.20.0";

  sha256 = "sha256-0qbJSCXHsVz3XILHICFhciyz92LgMZiR7XFLAESHRGQ=";

  nativeBuildInputs = lib.optionals withIntrospection [
    gobject-introspection
    vala # vala bindings require GObject introspection
  ];

  propagatedBuildInputs = [
    glib
  ];

  meta = with lib; {
    description = "Extension library for Xfce";
    mainProgram = "xfce4-kiosk-query";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
