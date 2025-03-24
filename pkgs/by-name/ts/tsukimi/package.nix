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
stdenv.mkDerivation rec {
  pname = "tsukimi";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "tsukinaha";
    repo = "tsukimi";
    tag = "v${version}";
    hash = "sha256-OxRxl/+JP3eqxc5b0pb6QbAAHrZgHrq1cawas2UrUro=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-kt3otu5N3KAzJT992v80Mbgr0sOoPnonc1+pu5ANIxE=";
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

  buildInputs =
    [
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
  versionCheckProgramArg = [ "--version" ];
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
}
