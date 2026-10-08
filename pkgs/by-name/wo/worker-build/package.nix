{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "worker-build";
  version = "0.8.6";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];
  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WnAwr7wQcgRIKNnZ5xdqk+/kK/bETZBl/P1YNIqQp8s=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-zvwk053ly1hFtldbawrXuqaLDAo807is8dlHLo5QTl8=";

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
