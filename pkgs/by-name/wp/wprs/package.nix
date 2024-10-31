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
  version = "0-unstable-2024-10-22";

  src = fetchFromGitHub {
    owner = "wayland-transpositor";
    repo = "wprs";
    rev = "6b993332c55568e66961b52bb6285e76d97d50df";
    hash = "sha256-WrPr9b1r8As4Y5c+QCOYnHvY9x145+pL4OSmrGsYDpk=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
    (python3.withPackages (pp: with pp; [ psutil ]))
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;

    outputHashes = {
      "divbuf-0.3.2-pre" = "sha256-xV0RWT4xu/LTVUGQSrafOgJ+X7FlnH7Cz6KreKSlCjw=";
      "smithay-0.3.0" = "sha256-lqAJACmkJ6Ap/zRGjJjwJbQOynUPPhXAApHS60jYLxo=";
      "smithay-client-toolkit-0.19.1" = "sha256-Sw/eM5rjaKVVFaEYaYj09jsxaLZTpD2IdQGpr/o0Fpc=";
    };
  };

  preFixup = ''
    cp  wprs "$out/bin/wprs"
  '';

  passthru.tests.sanity = runCommand "wprs-sanity" { nativeBuildInputs = [ wprs ]; } ''
    ${wprs}/bin/wprs -h > /dev/null && touch $out
  '';

  meta = with lib; {
    description = "rootless remote desktop access for remote Wayland";
    license = licenses.asl20;
    maintainers = with maintainers; [ mksafavi ];
    platforms = [ "x86_64-linux" ]; # The aarch64-linux support is not implemented in upstream yet. Also, the darwin platform is not supported as it requires wayland.
    homepage = "https://github.com/wayland-transpositor/wprs";
    mainProgram = "wprs";
  };
}
