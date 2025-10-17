{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
  pkg-config,
  ncurses,
  openssl,
}:

rustPlatform.buildRustPackage {
  pname = "taizen";
  version = "0-unstable-2023-06-05";

  src = fetchFromGitHub {
    owner = "oppiliappan";
    repo = "taizen";
    rev = "5486cd4f4c5aa4e0abbcee180ad2ec22839abd31";
    hash = "sha256-pGcD3+3Ds3U8NuNySaDnz0zzAvZlSDte1jRPdM5qrZA=";
  };

  cargoPatches = [
    # update cargo dependencies upstreamed: https://github.com/oppiliappan/taizen/pull/27
    (fetchpatch2 {
      name = "update-cargo-lock.patch";
      url = "https://github.com/oppiliappan/taizen/commit/104a1663268623e9ded45afaf2fe98c9c42b7b21.patch";
      hash = "sha256-ujsr7MjZWEu+2mijVH1aqtTJXKZC4m5vl73Jre9XHbU=";
    })
  ];

  cargoHash = "sha256-kK9na2Pk3Hl4TYYVVUfeBv6DDDkrD7mIv7eVHXkS5QY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ncurses
    openssl
  ];

  meta = with lib; {
    description = "Curses-based mediawiki browser";
    homepage = "https://github.com/oppiliappan/taizen";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "taizen";
  };
}
