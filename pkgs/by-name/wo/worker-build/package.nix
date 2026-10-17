{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "worker-build";
  version = "0.8.7";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];
  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZZFyZeu/PGwUatOWG/SPI7y+XyiuUyHO7L5y0qtJl70=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-AHTBKz8jwUaQpC03oH15NxtBQYO5PrvUVLwkz4+L5K8=";

  buildAndTestSubdir = "worker-build";

  meta = {
    description = "Tool to be used as a custom build command for a Cloudflare Workers `workers-rs` project";
    mainProgram = "worker-build";
    homepage = "https://github.com/cloudflare/workers-rs";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
