{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  mpv-unwrapped,
  ffmpeg,
  libadwaita,
  gst_all_1,
  openssl,
  libepoxy,
  wrapGAppsHook4,
  nix-update-script,
  stdenv,
  meson,
  ninja,
  rustc,
  cargo,
  dbus,
  desktop-file-utils,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tsukimi";
  version = "26.6.3";

  src = fetchFromGitHub {
    owner = "tsukinaha";
    repo = "tsukimi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q+WMwd4GEA1K0Ul8e3g+uBmaUT7nWA865vhuIioqqi4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-P77AS0+zbi2lfgkH5TDg9JdoYAiWJVdlgHs/ThU547U=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    meson
    ninja
    rustPlatform.cargoSetupHook
    rustc
    cargo
    desktop-file-utils
  ];

  buildInputs = [
    mpv-unwrapped
    ffmpeg
    libadwaita
    openssl
    libepoxy
    dbus
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ]);

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple third-party Emby client, featured with GTK4-RS, MPV and GStreamer";
    homepage = "https://github.com/tsukinaha/tsukimi";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      merrkry
      aleksana
    ];
    mainProgram = "tsukimi";
    platforms = lib.platforms.linux;
  };
})
