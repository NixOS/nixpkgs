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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "video-trimmer";
  version = "0.9.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "YaLTeR";
    repo = "video-trimmer";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-4B3NNGww+UjI/VbsKL62vWlKye7NYXYPzlJ4TfywJDw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    hash = "sha256-vtV5TrF81TK4PUwzOF/CuDsKH1vTLO+4PFufyIOp2zk=";
  };

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

  doCheck = true;

  strictDeps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ ffmpeg-headless ]}"
    )
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/YaLTeR/video-trimmer";
    description = "Trim videos quickly";
    maintainers =
      with lib.maintainers;
      [
        doronbehar
      ]
      ++ lib.teams.gnome-circle.members;
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "video-trimmer";
  };
})
