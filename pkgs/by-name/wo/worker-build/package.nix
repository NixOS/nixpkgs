{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "worker-build";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    tag = "v${version}";
    hash = "sha256-Ia921UNb++9Y1NoEd7nNdJaEEqRxQLAzZ8yYaxPrWYc=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-sIxsGeORhWpL3lWzXas7fK4QVuB03UT7rAN8uEzOdr0=";

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
}
