{
  stdenv,
  lib,
  mkXfceDerivation,
  python3,
  wayland-scanner,
  glib,
  gtk3,
  libdisplay-info,
  libwnck,
  libX11,
  libXrandr,
  wayland,
  wayland-protocols,
  wlr-protocols,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4windowing";
  version = "4.20.3";

  sha256 = "sha256-l58cTz28UPSVfoIpjBCoSwcqdUJfG9e4UlhVYPyEeAs=";

  nativeBuildInputs = [
    python3
    wayland-scanner
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk3
    libdisplay-info
    libwnck
    libX11
    libXrandr
    wayland
    wayland-protocols
    wlr-protocols
  ];

  postPatch = ''
    patchShebangs xdt-gen-visibility
  '';

  meta = {
    description = "Windowing concept abstraction library for X11 and Wayland";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.xfce ];
  };
}
