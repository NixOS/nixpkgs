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
    hash = "sha256-yCE18ERi+dPNHxjmVJVxg53/z7qNXZmIbgEsNZiucFE=";
  };

  cargoHash = "sha256-jSBXByRruga2xovXQQBLvNqxd7QR9s6AQu8M3JGIsmM=";

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
  };
})
