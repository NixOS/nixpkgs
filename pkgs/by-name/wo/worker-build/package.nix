{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "worker-build";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    tag = "v${version}";
    hash = "sha256-eP54+M6eXp251QHF9YX5f19yL7gC+zsZfbphac363Wo=";
  };

  cargoHash = "sha256-1KVpcghdGG6gcDz5rvydYLXXh/5Yiq1Z2Rtbc66DWrM=";

  buildAndTestSubdir = "worker-build";

  # missing some module upstream to run the tests
  doCheck = false;

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
