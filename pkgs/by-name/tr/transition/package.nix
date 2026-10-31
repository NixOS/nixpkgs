{
  lib,
  stdenv,
  fetchFromCodeberg,
  rustPlatform,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustc,
  wrapGAppsHook4,
  libadwaita,
  gst_all_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "transition";
  version = "3.0";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "grinka";
    repo = "transition";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j4K6HvUC3pVMQE76S2mNOaCD6u05r8uxpqZ4H+DZLH4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-66gRgzQkmeeMQG0pi9JEFn/KUOUE9mIH136pL7NwGhU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    gst_all_1.gst-plugins-base
  ];

  mesonFlags = [
    "-Dprofile=release"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/transition --help > /dev/null
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://codeberg.org/grinka/transition";
    description = "Simple multimedia to audio conversion";
    maintainers = with lib.maintainers; [ lethargii ];
    changelog = "https://codeberg.org/grinka/transition/releases";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "transition";
  };
})
