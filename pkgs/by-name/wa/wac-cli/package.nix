{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wac-cli";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LZ8d6J9akOrXbmbQ6OOl2sTHYWvObRTyV2I8Uloa64M=";
  };

  cargoHash = "sha256-CVNFPvcdGyndV4UURa/RY0g8J90qkp3RiuyZNOXRVIE=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "WebAssembly Composition (WAC) tooling";
    license = lib.licenses.asl20;
    homepage = "https://github.com/bytecodealliance/wac";
    maintainers = with lib.maintainers; [ water-sucks ];
    mainProgram = "wac";
  };
})
