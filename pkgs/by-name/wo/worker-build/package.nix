{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "worker-build";
  version = "0.8.3";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];
  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sRKQALNYUmzxaqYJCWR8b3yvqg8e4EHe1Cm7vqRx8hU=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-enePrsTLpiTDxqnFFD38N4amOKY5oHHctPl9RFj2eRo=";

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
