{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "worker-build";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    tag = "v${version}";
    hash = "sha256-c0PXLuWEY+keYRAjQkgd84Hn7IDh17SePKDF9J4ZQ5M=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-axK9/EVNKBb4xoYMOJ+0Y5nQvtkYyFDE6RsiL2MqxTM=";

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
