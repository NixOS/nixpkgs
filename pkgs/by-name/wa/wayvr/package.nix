{
  alsa-lib,
  dav1d,
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
  version = "26.7.1";

  src = fetchFromGitHub {
    owner = "wayvr-org";
    repo = "wayvr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SdHN3jDe2QJaRORy452RP7kTMxPOZOB/yjpApUOLhRU=";
  };

  cargoHash = "sha256-eGmlFtlorKG7uygLer3UW6ERLQzdugoYyXVSC2sFh+k=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    dav1d
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

  postInstall = ''
    install -D wayvr/wayvr.desktop -t $out/share/applications
    install -D wayvr/wayvr.svg -t $out/share/icons/hicolor/scalable/apps

    rm $out/bin/prost_build
  '';

  passthru = {
    tests.testVersion = testers.testVersion { package = wayvr; };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Your way to enjoy VR on Linux! Access your Wayland/X11 desktop from SteamVR/Monado (OpenVR+OpenXR support)";
    homepage = "https://github.com/wayvr-org/wayvr";
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
