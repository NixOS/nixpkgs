{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "wolfetch";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "TrueWulf";
    repo = "wolfetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U6p2uyhqeKnCaXv3U8Z3riS6pBQGPuPrJ3e8adZr3Gk=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postInstall = ''
    ln -s $out/bin/wolfetch $out/bin/wfetch
  '';

  meta = {
    description = "Tiny and fast system fetch for Linux and BSD";
    homepage = "https://github.com/TrueWulf/wolfetch";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "wolfetch";
  };
})
