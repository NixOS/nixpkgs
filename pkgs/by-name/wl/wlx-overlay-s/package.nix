{
  alsa-lib,
  dbus,
  fetchFromGitHub,
  fontconfig,
  lib,
  libGL,
  libX11,
  libxcb,
  libXext,
  libXrandr,
  libxkbcommon,
  makeWrapper,
  nix-update-script,
  openvr,
  openxr-loader,
  pipewire,
  pkg-config,
  pulseaudio,
  rustPlatform,
  shaderc,
  stdenv,
  testers,
  wayland,
  wlx-overlay-s,
  # openvr support is broken on aarch64-linux
  withOpenVr ? !stdenv.hostPlatform.isAarch64,
}:

rustPlatform.buildRustPackage rec {
  pname = "wlx-overlay-s";
  version = "25.4.2";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "wlx-overlay-s";
    rev = "v${version}";
    hash = "sha256-lWUfhiHRxu72p9ZG2f2fZH6WZECm/fOKcK05MLZV+MI=";
  };

  cargoHash = "sha256-em5sWSty2/pZp2jTwBnLUIBgPOcoMpwELwj984XYf+k=";

  # explicitly only add openvr if withOpenVr is set to true.
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "openxr"
    "osc"
    "x11"
    "wayland"
    "wayvr"
  ]
  ++ lib.optional withOpenVr "openvr";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    dbus
    fontconfig
    libGL
    libX11
    libxcb
    libXext
    libXrandr
    libxkbcommon
    openxr-loader
    pipewire
    wayland
  ]
  ++ lib.optional withOpenVr openvr;

  env.SHADERC_LIB_DIR = "${lib.getLib shaderc}/lib";

  postPatch = ''
    substituteAllInPlace src/res/watch.yaml \
      --replace '"pactl"' '"${lib.getExe' pulseaudio "pactl"}"'

    # TODO: src/res/keyboard.yaml references 'whisper_stt'
  '';

  passthru = {
    tests.testVersion = testers.testVersion { package = wlx-overlay-s; };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Wayland/X11 desktop overlay for SteamVR and OpenXR, Vulkan edition";
    homepage = "https://github.com/galister/wlx-overlay-s";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Scrumplex ];
    platforms = lib.platforms.linux;
    broken = stdenv.hostPlatform.isAarch64 && withOpenVr;
    mainProgram = "wlx-overlay-s";
  };
}
