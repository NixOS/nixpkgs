{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vpkmerge-cli";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "Slush97";
    repo = "vpkmerge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U+5RwdWv7CkmMHb5/kLbLfbqljFHFMQqJTsd4M3SJBI=";
  };

  cargoHash = "sha256-6B7B4Q8ae1csttZPEspuQL25g4viVYc27f2vR4zLWNg=";

  buildAndTestSubdir = "vpkmerge-cli";

  __structuredAttrs = true;

  meta = {
    description = "Command-line tool to combine and split Valve Pak (VPK) files";
    homepage = "https://github.com/Slush97/vpkmerge";
    license = lib.licenses.mit;
    mainProgram = "vpkmerge";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ justdeeevin ];
  };
})
