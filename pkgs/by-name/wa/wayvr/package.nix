{
  alsa-lib,
  dbus,
  fetchFromGitHub,
  lib,
  libX11,
  libXext,
  libXrandr,
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
rustPlatform.buildRustPackage rec {
  pname = "wayvr";
  version = "26.1.2";

  src = fetchFromGitHub {
    owner = "wlx-team";
    repo = "wayvr";
    tag = "v${version}";
    hash = "sha256-UZ5zcalez6B+212OqCaEXSoRfhaExuy0W8HX8b4flSU=";
  };

  cargoHash = "sha256-zqB2ybdpQEGdlkNin6mlUfaVRkpOtFl2CVCLAdKDMoQ=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    dbus
    libX11
    libXext
    libXrandr
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
}
