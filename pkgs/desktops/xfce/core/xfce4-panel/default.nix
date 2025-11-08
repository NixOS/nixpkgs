{
  stdenv,
  lib,
  mkXfceDerivation,
  python3,
  cairo,
  exo,
  garcon,
  gtk-layer-shell,
  gtk3,
  libdbusmenu-gtk3,
  libwnck,
  libxfce4ui,
  libxfce4util,
  libxfce4windowing,
  tzdata,
  wayland,
  xfconf,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
  vala,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-panel";
  version = "4.20.5";

  sha256 = "sha256-Jftj+EmmsKfK9jk8rj5uMjpteFUHFgOpoEol8JReDNI=";

  nativeBuildInputs = [
    python3
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala # vala bindings require GObject introspection
  ];

  buildInputs = [
    cairo
    exo
    garcon
    gtk-layer-shell
    libdbusmenu-gtk3
    libxfce4ui
    libxfce4windowing
    libwnck
    tzdata
    wayland
    xfconf
  ];

  propagatedBuildInputs = [
    gtk3
    libxfce4util
  ];

  postPatch = ''
    patchShebangs xdt-gen-visibility

    substituteInPlace plugins/clock/clock.c \
       --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  meta = with lib; {
    description = "Panel for the Xfce desktop environment";
    teams = [ teams.xfce ];
  };
}
