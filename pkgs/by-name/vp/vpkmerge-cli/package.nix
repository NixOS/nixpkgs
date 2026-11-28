{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vpkmerge-cli";
  version = "0.30.1";

  src = fetchFromGitHub {
    owner = "Slush97";
    repo = "vpkmerge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mPMSHBLE3BROnTUis7d+7v0tc2BpOx9nHOVGmjJXRx4=";
  };

  cargoHash = "sha256-vq9DZJPa/nCR3RszyLWtylG73cDoIrB9jXFpb+6supw=";

  buildAndTestSubdir = "vpkmerge-cli";

  __structuredAttrs = true;

  meta = {
    description = "Command-line tool to combine and split Valve Pak (VPK) files";
    homepage = "https://github.com/Slush97/vpkmerge";
    license = lib.licenses.mit;
    mainProgram = "vpkmerge";
    maintainers = with lib.maintainers; [
      justdeeevin
      gegnep
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
