{
  stdenv,
  lib,
  mkXfceDerivation,
  fetchpatch,
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
  version = "4.20.4";

  sha256 = "sha256-P1EZefpGRZ0DQ5S4Okw9pyly23d+UdPp5xMj1wJc44c=";

  patches = [
    # Fixes panel not shown on external display after reconnecting
    # https://gitlab.xfce.org/xfce/xfce4-panel/-/issues/925
    (fetchpatch {
      url = "https://gitlab.xfce.org/xfce/xfce4-panel/-/commit/e2451cacd950f4b7539efd1e5e36b067515dba9b.patch";
      hash = "sha256-h2iPlghHJeHD9PJp6RJrRx4MBsaqXuNclAJW6CKHE4A=";
    })
  ];

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
