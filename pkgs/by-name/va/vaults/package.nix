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
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "mpobaschnig";
    repo = "vaults";
    tag = version;
    hash = "sha256-B4CNEghMfP+r0poyhE102zC1Yd2U5ocV1MCMEVEMjEY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-my4CxFIEN19juo/ya2vlkejQTaZsyoYLtFTR7iCT9s0=";
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
