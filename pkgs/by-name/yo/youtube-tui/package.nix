{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  xorg,
  stdenv,
  python3,
  makeBinaryWrapper,
  libsixel,
  mpv,
}:

rustPlatform.buildRustPackage rec {
  pname = "youtube-tui";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Siriusmart";
    repo = "youtube-tui";
    tag = "v${version}";
    hash = "sha256-svZoE7WuBlehYVRRn8S0rR2/5j87DLreqARmfLyHdLg=";
  };

  cargoHash = "sha256-cFee80E/XI4EI5EW8gfB4OOCltJaPS4asE0AXTAGv/k=";

  nativeBuildInputs = [
    pkg-config
    python3
    makeBinaryWrapper
  ];

  buildInputs = [
    openssl
    xorg.libxcb
    libsixel
    mpv
  ];

  # sixel-sys is dynamically linked to libsixel
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    wrapProgram $out/bin/youtube-tui \
      --prefix DYLD_LIBRARY_PATH : "${lib.makeLibraryPath [ libsixel ]}"
  '';

  meta = with lib; {
    description = "Aesthetically pleasing YouTube TUI written in Rust";
    homepage = "https://siriusmart.github.io/youtube-tui";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Ruixi-rebirth ];
    mainProgram = "youtube-tui";
  };
}
