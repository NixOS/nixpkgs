{
  alsa-lib,
  autoPatchelfHook,
  dav1d,
  dbus,
  fetchFromGitHub,
  lib,
  libinput,
  libx11,
  libxcursor,
  libxext,
  libxrandr,
  libxcb,
  libxi,
  libxkbcommon,
  nix-update-script,
  openssl,
  openvr,
  openxr-loader,
  pipewire,
  pkg-config,
  procps,
  pulseaudio,
  replaceVars,
  rustPlatform,
  shaderc,
  stdenv,
  testers,
  vulkan-loader,
  wayland,
  wayvr,
  xwayland-satellite,
  makeWrapper,
  libGL,
  libuuid,
  withOpenVR ? !stdenv.hostPlatform.isAarch64,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wayvr";
  version = "26.8.0";

  src = fetchFromGitHub {
    owner = "wayvr-org";
    repo = "wayvr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0llU19bFJJ4yJvA6eGzOzyW8TnnurTS9js3/r+UAVCQ=";
  };

  patches = [
    (replaceVars ./use-system-xwayland-satellite.patch {
      xwayland-satellite = lib.getExe xwayland-satellite;
    })
  ];

  cargoHash = "sha256-yUHLtB3/cBEWVAN1vuGLLlLFqJ25ucIy6qqInTGaOvA=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    autoPatchelfHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    dav1d
    dbus
    libinput
    # X dependencies are dlopen'd at runtime by uidev
    libx11
    libxext
    libxrandr
    libxcb
    libxkbcommon
    openssl
    openxr-loader
    pipewire

    # only dlopen'd at runtime by uidev
    libxcursor
    libxi
    wayland
    vulkan-loader
  ]
  ++ lib.optionals withOpenVR [
    libGL
    openvr
    libuuid
  ];

  env.SHADERC_LIB_DIR = "${lib.getLib shaderc}/lib";

  postPatch = ''
    substituteInPlace dash-frontend/src/util/pactl_wrapper.rs \
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

    # This really is not optimal but wayvr will complain about missing libraries and refuse to start with --openvr.
    # steam-run *should* provide most of these libraries but for some whatever reason it doesnt, this is a workaround for now.
    wrapProgram $out/bin/wayvr \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}
  '';

  preFixup = ''
    patchelf \
      --add-needed libwayland-client.so.0 \
      --add-needed libwayland-cursor.so.0 \
      --add-needed libwayland-egl.so.1 \
      --add-needed libX11.so.6 \
      --add-needed libxcb.so.1 \
      --add-needed libXcursor.so.1 \
      --add-needed libXi.so.6 \
      --add-needed libvulkan.so.1 \
      --add-needed libxkbcommon.so.0 \
      $out/bin/uidev
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
    maintainers = with lib.maintainers; [
      Scrumplex
      ImSapphire
      ShyAssassin
    ];
    platforms = lib.platforms.linux;
    broken = stdenv.hostPlatform.isAarch64 && withOpenVR;
    mainProgram = "wayvr";
  };
})
