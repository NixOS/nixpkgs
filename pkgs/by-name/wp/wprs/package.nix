{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  python3,
  runCommand,
  wprs,
}:
rustPlatform.buildRustPackage {
  pname = "wprs";
  version = "0-unstable-2025-10-04";

  src = fetchFromGitHub {
    owner = "wayland-transpositor";
    repo = "wprs";
    rev = "e8bce459839ab0c3cab256d700ca62a19327839f";
    hash = "sha256-6ykqj28UC29AwvWkK9/G+YNhtdL7kgjJq1F1uDIFAXs=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
    (python3.withPackages (pp: with pp; [ psutil ]))
  ];

  cargoHash = "sha256-krrVgdoCcW3voSiQAoWsG+rPf1HYKbuGhplhn21as2c=";

  RUSTFLAGS = "-C target-feature=+avx2"; # only works on x86 systems supporting AVX2

  preFixup = ''
    cp  wprs "$out/bin/wprs"
  '';

  passthru.tests.sanity = runCommand "wprs-sanity" { nativeBuildInputs = [ wprs ]; } ''
    ${wprs}/bin/wprs -h > /dev/null && touch $out
  '';

  meta = {
    description = "Rootless remote desktop access for remote Wayland";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mksafavi ];
    platforms = [ "x86_64-linux" ]; # The aarch64-linux support is not implemented in upstream yet. Also, the darwin platform is not supported as it requires wayland.
    homepage = "https://github.com/wayland-transpositor/wprs";
    mainProgram = "wprs";
  };
}
