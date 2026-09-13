{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  python3,
  runCommand,
  wprs,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "wprs";
  version = "0-unstable-2026-03-23";

  src = fetchFromGitHub {
    owner = "wayland-transpositor";
    repo = "wprs";
    rev = "309ab853cc09cf7fef0370e245367726ea51121f";
    hash = "sha256-2hgIsGt0z+p8dwb7bCJQvxMISr6vQ5cnU0d4jqkif5Y=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
    (python3.withPackages (pp: with pp; [ psutil ]))
  ];

  cargoHash = "sha256-KiZzAhcuqG/+aFzr1u6Rw7LOr1q2PWDe559gQ5g5YqA=";

  postInstall = ''
    install -Dm755 wprs "$out/bin/wprs"
  '';

  passthru = {
    tests.sanity = runCommand "wprs-sanity" { nativeBuildInputs = [ wprs ]; } ''
      ${wprs}/bin/wprs -h > /dev/null && touch $out
    '';
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch=master" ];
    };
  };

  meta = {
    description = "Rootless remote desktop access for remote Wayland";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mksafavi
      nadja-y
    ];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/wayland-transpositor/wprs";
    mainProgram = "wprs";
  };
}
