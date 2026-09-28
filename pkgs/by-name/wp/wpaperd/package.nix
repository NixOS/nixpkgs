{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  wayland,
  libGL,
  dav1d,
  installShellFiles,
  scdoc,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wpaperd";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "danyspin97";
    repo = "wpaperd";
    tag = finalAttrs.version;
    hash = "sha256-gKO2GDR21LPx+09YUnV/wMs1uVBRDHkbY6GonTmTPPA=";
  };

  cargoHash = "sha256-dfmezhRdnKx53y9ETx2nJrILz/zgu07RuqqmGdRyhdY=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    scdoc
  ];
  buildInputs = [
    wayland
    libGL
    libxkbcommon
    dav1d
    rust-jemalloc-sys
  ];

  buildFeatures = [
    "avif"
  ];

  postBuild = ''
    scdoc < man/wpaperd-output.5.scd > man/wpaperd-output.5
  '';

  postInstall =
    let
      targetDir = "target/*/$cargoBuildType";
    in
    ''
      installShellCompletion ${targetDir}/completions/*.{bash,fish}
      installShellCompletion --zsh ${targetDir}/completions/_*
      installManPage ${targetDir}/man/*.1 man/*.5
    '';

  meta = {
    description = "Minimal wallpaper daemon for Wayland";
    longDescription = ''
      It allows the user to choose a different image for each output (aka for each monitor)
      just as swaybg. Moreover, a directory can be chosen and wpaperd will randomly choose
      an image from it. Optionally, the user can set a duration, after which the image
      displayed will be changed with another random one.
    '';
    homepage = "https://github.com/danyspin97/wpaperd";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      DPDmancul
      fsnkty
    ];
    mainProgram = "wpaperd";
  };
})
