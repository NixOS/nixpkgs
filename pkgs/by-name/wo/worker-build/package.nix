{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "worker-build";
  version = "0.8.5";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];
  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t+Hmgzc+xbOsEY7exHiR1dIuO8Fpb1wO613Dj2SZ6gI=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-Iolcx7CcGSlHgnKjmiGdkd/NTAsma5bT/H0+7V3UR3Y=";

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
