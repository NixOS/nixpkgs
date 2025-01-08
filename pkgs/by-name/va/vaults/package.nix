{
  fetchFromGitHub,
  lib,
  stdenv,
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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "mpobaschnig";
    repo = "Vaults";
    rev = "v${version}";
    hash = "sha256-USVP/7TNdpUNx1kDsCReGYIP8gHUeij2dqy8TR4R+CE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-h25YRqQ4Z+Af+zHITnmnwpg09V7sik88YRGbG8BZUjg=";
  };

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
