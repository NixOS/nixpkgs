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
  version = "0-unstable-2026-08-31";

  src = fetchFromGitHub {
    owner = "wayland-transpositor";
    repo = "wprs";
    rev = "12b864dc5b308e63edede4714f664afa88507fce";
    hash = "sha256-fWJlXMY0tKGmpdG/9vcz7Kc0ckucWHLS2kcUU7r3fwc=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
    (python3.withPackages (pp: with pp; [ psutil ]))
  ];

  cargoHash = "sha256-khU7SfEfEIlRqI0bFxP57cVUxoIBRso7o0Rw+i2MtSc=";

  env.RUSTFLAGS = "-C target-feature=+avx2"; # only works on x86 systems supporting AVX2

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
