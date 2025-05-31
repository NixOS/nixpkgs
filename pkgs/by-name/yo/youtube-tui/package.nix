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
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "Siriusmart";
    repo = "youtube-tui";
    tag = "v${version}";
    hash = "sha256-pt/lKvNDd3gji2+Ubd/ARiuV5MvdSxMfzJubACXTcUc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JbG+fYyHC6Li4kuNjQRS7gxU7nLADMEqTZQEBRAASjM=";

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
