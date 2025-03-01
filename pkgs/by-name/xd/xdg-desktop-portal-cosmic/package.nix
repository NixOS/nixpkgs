{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  pkg-config,
  util-linux,
  libgbm,
  pipewire,
  gst_all_1,
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-cosmic";
  version = "1.0.0-alpha.5.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    tag = "epoch-${version}";
    hash = "sha256-wff805IIXrXC/kn5l4HrYenxNRTGDYHPmT7qTTtBi/c=";
  };

  env = {
    VERGEN_GIT_COMMIT_DATE = "2025-01-14";
    VERGEN_GIT_SHA = src.rev;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Dwlow5nUl7qHLfu4Acic2CRCJViylpPLyLBVtBgWd9A=";

  separateDebugInfo = true;

  nativeBuildInputs = [
    libcosmicAppHook
    rustPlatform.bindgenHook
    pkg-config
    util-linux
  ];

  buildInputs = [
    libgbm
    pipewire
  ];

  checkInputs = [ gst_all_1.gstreamer ];

  dontCargoInstall = true;

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  meta = {
    homepage = "https://github.com/pop-os/xdg-desktop-portal-cosmic";
    description = "XDG Desktop Portal for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nyabinary ];
    mainProgram = "xdg-desktop-portal-cosmic";
    platforms = lib.platforms.linux;
  };
}
