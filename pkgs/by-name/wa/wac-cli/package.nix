{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wac-cli";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nNFdEU0T7Zf9q3boozA0fU+9sCxhnUGf/azVtNesIac=";
  };

  cargoHash = "sha256-seLmdg6p644E/XqyCqTGjufMuXkR9PBtoEvjrp664Go=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "WebAssembly Composition (WAC) tooling";
    license = lib.licenses.asl20;
    homepage = "https://github.com/bytecodealliance/wac";
    maintainers = with lib.maintainers; [ water-sucks ];
    mainProgram = "wac";
  };
})
