{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  python3,
  rustPlatform,
  rustc,
  cargo,
  wrapGAppsHook3,
  glib,
  gtk4,
  libadwaita,
  wayland,
  gocryptfs,
  cryfs,
}:

stdenv.mkDerivation rec {
  pname = "vaults";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "mpobaschnig";
    repo = "vaults";
    tag = version;
    hash = "sha256-PczDj6G05H6XbkMQBr4e1qgW5s8GswEA9f3BRxsAWv0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-j0A6HlApV0l7LuB7ISHp+k/bSH5Icdv+aNQ9juCCO9I=";
  };

  patches = [ ./not-found-flatpak-info.patch ];

  postPatch = ''
    patchShebangs build-aux
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${
        lib.makeBinPath [
          gocryptfs
          cryfs
        ]
      }"
    )
  '';

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    appstream-glib
    gtk4
    python3
    glib
    libadwaita
    wayland
    gocryptfs
    cryfs
  ];

  meta = {
    description = "GTK frontend for encrypted vaults supporting gocryptfs and CryFS for encryption";
    homepage = "https://mpobaschnig.github.io/vaults/";
    changelog = "https://github.com/mpobaschnig/vaults/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      benneti
      aleksana
    ];
    mainProgram = "vaults";
    platforms = lib.platforms.linux;
  };
}
