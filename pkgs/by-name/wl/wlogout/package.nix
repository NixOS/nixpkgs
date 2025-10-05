{
  lib,
  fetchFromGitHub,
  gitUpdater,
  gtk-layer-shell,
  gtk3,
  libxkbcommon,
  meson,
  ninja,
  pkg-config,
  scdoc,
  stdenv,
  wayland,
  wayland-protocols,
  # gtk-layer-shell fails to cross-compile due to a hard dependency
  # on gobject-introspection.
  # Disable it when cross-compiling since it's an optional dependency.
  # This disables transparency support.
  withGtkLayerShell ? (stdenv.buildPlatform == stdenv.hostPlatform),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wlogout";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "ArtsyMacaw";
    repo = "wlogout";
    rev = finalAttrs.version;
    hash = "sha256-/tYZy56ku68ziSOhy6Dex9RGy+blkU6CN2ze76y7718=";
  };

  outputs = [
    "out"
    "man"
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    gtk3
    libxkbcommon
    wayland
    wayland-protocols
  ]
  ++ lib.optionals withGtkLayerShell [
    gtk-layer-shell
  ];

  strictDeps = true;

  mesonFlags = [
    "--datadir=${placeholder "out"}/share"
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  postPatch = ''
    substituteInPlace style.css \
      --replace "/usr/share/wlogout" "$out/share/wlogout"

    substituteInPlace main.c \
      --replace "/etc/wlogout" "$out/etc/wlogout"
  '';

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    homepage = "https://github.com/ArtsyMacaw/wlogout";
    description = "Wayland based logout menu";
    changelog = "https://github.com/ArtsyMacaw/wlogout/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [ mit ];
    mainProgram = "wlogout";
    maintainers = with lib.maintainers; [ ];
    inherit (wayland.meta) platforms;
  };
})
