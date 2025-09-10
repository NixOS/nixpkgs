{
  stdenv,
  lib,
  fetchFromGitLab,
  rustPlatform,
  cargo,
  pkg-config,
  meson,
  rustc,
  wrapGAppsHook4,
  desktop-file-utils,
  blueprint-compiler,
  ninja,
  gtk4,
  libadwaita,
  gst_all_1,
  ffmpeg-headless,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "video-trimmer";
  version = "25.03";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "YaLTeR";
    repo = "video-trimmer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pJCXL0voOoc8KpYECYRWGefYMrsApNPST4wv8SQlH34=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-3ycc4jXneGsz9Jp9Arzf224JPAKM+PxUkitWcIXre8Y=";
  };

  postPatch = ''
    substituteInPlace build-aux/cargo.sh --replace-fail \
      'cp "$CARGO_TARGET_DIR"/' \
      'cp "$CARGO_TARGET_DIR"/${stdenv.hostPlatform.rust.cargoShortTarget}/'
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    wrapGAppsHook4
    desktop-file-utils
    blueprint-compiler
    ninja
    # Present here in addition to buildInputs, because meson runs
    # `gtk4-update-icon-cache` during installPhase, thanks to:
    # https://gitlab.gnome.org/YaLTeR/video-trimmer/-/merge_requests/12
    gtk4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good # for scaletempo and webm
    gst_all_1.gst-plugins-bad
  ];

  # For https://gitlab.gnome.org/YaLTeR/video-trimmer/-/blob/cf64e8dea345bcd991db29a3f862a9277c71fe81/build-aux/cargo.sh#L19
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  doCheck = true;

  strictDeps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ ffmpeg-headless ]}"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/YaLTeR/video-trimmer";
    description = "Trim videos quickly";
    changelog = "https://gitlab.gnome.org/YaLTeR/video-trimmer/-/releases/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      doronbehar
    ];
    teams = [ lib.teams.gnome-circle ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "video-trimmer";
  };
})
