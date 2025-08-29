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
}:

rustPlatform.buildRustPackage rec {
  pname = "wpaperd";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "danyspin97";
    repo = "wpaperd";
    rev = version;
    hash = "sha256-mBdrOmS+e+Npei5+RmtbTkBCGR8L5O83hulNU1z0Akk=";
  };

  cargoHash = "sha256-d8jzoNCn9J36SE4tQZ1orgOfFGbhVtHaaO940b3JxmQ=";

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

  meta = with lib; {
    description = "Minimal wallpaper daemon for Wayland";
    longDescription = ''
      It allows the user to choose a different image for each output (aka for each monitor)
      just as swaybg. Moreover, a directory can be chosen and wpaperd will randomly choose
      an image from it. Optionally, the user can set a duration, after which the image
      displayed will be changed with another random one.
    '';
    homepage = "https://github.com/danyspin97/wpaperd";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      DPDmancul
      fsnkty
    ];
    mainProgram = "wpaperd";
  };
}
