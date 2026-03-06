{
  alsa-lib,
  dbus,
  fetchFromGitHub,
  lib,
  libx11,
  libxext,
  libxrandr,
  libxcb,
  libxkbcommon,
  nix-update-script,
  openssl,
  openvr,
  openxr-loader,
  pipewire,
  pkg-config,
  procps,
  pulseaudio,
  rustPlatform,
  shaderc,
  stdenv,
  testers,
  wayvr,
  withOpenVR ? !stdenv.hostPlatform.isAarch64,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wayvr";
  version = "26.2.1";

  src = fetchFromGitHub {
    owner = "wlx-team";
    repo = "wayvr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v1Wkelru825KV+ciXD9esLq39oTyMm/Z4rRbN+jjviY=";
  };

  cargoHash = "sha256-d6iRaOHq+4j90L76bx7+EwCLOY4MxPeqm3ELJ5H9O+8=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    dbus
    libx11
    libxext
    libxrandr
    libxcb
    libxkbcommon
    openssl
    openxr-loader
    pipewire
  ]
  ++ lib.optionals withOpenVR [ openvr ];

  env.SHADERC_LIB_DIR = "${lib.getLib shaderc}/lib";

  postPatch = ''
    substituteAllInPlace dash-frontend/src/util/pactl_wrapper.rs \
      --replace-fail '"pactl"' '"${lib.getExe' pulseaudio "pactl"}"'

    # steam_utils also calls xdg-open as well as steam. Those should probably be pulled from the environment
    substituteInPlace dash-frontend/src/util/steam_utils.rs \
      --replace-fail '"pkill"' '"${lib.getExe' procps "pkill"}"'
  '';

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "openxr"
    "osc"
    "x11"
    "wayland"
  ]
  ++ lib.optionals withOpenVR [ "openvr" ];

  passthru = {
    tests.testVersion = testers.testVersion { package = wayvr; };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Your way to enjoy VR on Linux! Access your Wayland/X11 desktop from SteamVR/Monado (OpenVR+OpenXR support)";
    homepage = "https://github.com/wlx-team/wayvr";
    license = with lib.licenses; [
      gpl3Only
      mit # wayvr-ipc
    ];
    maintainers = with lib.maintainers; [ Scrumplex ];
    platforms = lib.platforms.linux;
    broken = stdenv.hostPlatform.isAarch64 && withOpenVR;
    mainProgram = "wayvr";
  };
})
