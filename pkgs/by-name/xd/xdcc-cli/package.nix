{
  lib,
  pkgs,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xdcc-cli";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "jreiml";
    repo = "xdcc-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rPMerxQLB+/S3FtM4e5lCk0yAOUtWRhA8debwxbqmNI=";
  };

  cargoHash = "sha256-qAQkKGyLEUR4Pf5KVjqBsdyFxsgD/docRWKrQsf7KVo=";

  meta = {
    description = "CLI tool for downloading files using XDCC written in Rust";
    homepage = "https://github.com/jreiml/xdcc-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guilhermenl ];
    platforms = lib.platforms.unix;
    mainProgram = "xdcc-cli";
  };
})
