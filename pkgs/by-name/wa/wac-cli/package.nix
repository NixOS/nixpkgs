{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wac-cli";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XfUi+ANWhgxKVFpx+7iPxivB9/H8xuCdFde4wppJlUg=";
  };

  cargoHash = "sha256-qaf3Kc7bBnqE+ecap5yUuLdQ8gXaRaIPE+uA8Hq9wDQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "WebAssembly Composition (WAC) tooling";
    license = lib.licenses.asl20;
    homepage = "https://github.com/bytecodealliance/wac";
    maintainers = with lib.maintainers; [ water-sucks ];
    mainProgram = "wac";
  };
})
