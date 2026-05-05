{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  glib,
  libcosmicAppHook,
  pkg-config,
  util-linux,
  libgbm,
  pipewire,
  gst_all_1,
  cosmic-wallpapers,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xdg-desktop-portal-cosmic";
  version = "1.0.12";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-o1H5Cw20sgcE8I5L5u64YM6l+vhlHIcaY6cEH9it0gQ=";
  };

  cargoHash = "sha256-/7jxEktXW1+4nFK7ZFUO3oJhmLNuKMwErnqwgjBQiao=";

  separateDebugInfo = true;
  strictDeps = true;

  nativeBuildInputs = [
    libcosmicAppHook
    rustPlatform.bindgenHook
    pkg-config
    util-linux
  ];

  buildInputs = [
    glib
    libgbm
    pipewire
  ];

  checkInputs = [ gst_all_1.gstreamer ];

  postPatch = ''
    substituteInPlace src/screenshot.rs src/widget/screenshot.rs \
      --replace-fail '/usr/share/backgrounds' '${cosmic-wallpapers}/share/backgrounds'
  '';

  dontCargoInstall = true;

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  passthru = {
    tests = {
      inherit (nixosTests)
        cosmic
        cosmic-autologin
        cosmic-noxwayland
        cosmic-autologin-noxwayland
        ;
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/xdg-desktop-portal-cosmic";
    description = "XDG Desktop Portal for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    mainProgram = "xdg-desktop-portal-cosmic";
    platforms = lib.platforms.linux;
  };
})
