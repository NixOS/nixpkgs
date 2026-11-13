{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "worker-build";
  version = "0.9.0";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];
  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zmeQp7db2rwfECp9p5NthKvzsZFnQPFO+eueIhFsIwE=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-EbRwSrxRys2EcDfB88apmH5Rm0NUWLKtmGPS77fAhpI=";

  buildAndTestSubdir = "worker-build";

  meta = {
    description = "Tool to be used as a custom build command for a Cloudflare Workers `workers-rs` project";
    mainProgram = "worker-build";
    homepage = "https://github.com/cloudflare/workers-rs";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
