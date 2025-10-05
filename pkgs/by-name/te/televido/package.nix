{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  cargo,
  wrapGAppsHook4,
  blueprint-compiler,
  libadwaita,
  desktop-file-utils,
  openssl,
  gst_all_1,
  clapper-unwrapped,
}:

stdenv.mkDerivation rec {
  pname = "televido";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "d-k-bo";
    repo = "televido";
    tag = "v${version}";
    hash = "sha256-9hoKX1fGjMOlvU3kNx4aLMV++k+nynDIK1UQRrw242k=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-D9gchFS5zrD1cttq/gveT7wY2Y/5hfiUrwBa7qHD9cs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    cargo
    wrapGAppsHook4
    blueprint-compiler
    openssl
  ];

  buildInputs = [
    libadwaita
    desktop-file-utils
    clapper-unwrapped
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
  ];

  meta = {
    description = "Viewer for German-language public broadcasting live streams and archives";
    homepage = "https://github.com/d-k-bo/televido";
    license = lib.licenses.gpl3;
    mainProgram = "televido";
    maintainers = with lib.maintainers; [ seineeloquenz ];
    platforms = lib.platforms.linux;
  };
}
