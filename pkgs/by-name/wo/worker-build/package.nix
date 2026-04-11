{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "worker-build";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LeW0CHYBaib81AqftYpW38FFR3P7q7OJE2NmrK9oi9Q=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-W1m7W7LepgZ3WPjmZ7qXlu3WnvZkpGO35sHryOFqhfk=";

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
