{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libsixel,
  withSixel ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "viu";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+6oo6cJ0L3XuMWZL/8DEKMk6PI7D5IcfoemqIQiOJto=";
  };

  # tests need an interactive terminal
  doCheck = false;

  cargoHash = "sha256-gqMG3ATyGTx54Q43Hquc8A/H8fhdgVP1JLh5FGtWTTU=";

  buildFeatures = lib.optional withSixel "sixel";
  buildInputs = lib.optional withSixel libsixel;

  meta = {
    description = "Command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      chuangzhu
      sigmanificient
    ];
    mainProgram = "viu";
  };
})
