{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "txm";
  version = "0.1.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "thatmagicalcat";
    repo = "txm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZpR4uCjGP3GdMbwNTflQNReytPsJjfFw7OdU4P6bDTw=";
  };

  cargoHash = "sha256-G6C0Z1TMTjzXwbzpuimw6v7FOl2V+M1NjjcgEKPTKwA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal math rendering engine with LaTeX support";
    homepage = "https://github.com/thatmagicalcat/txm";
    changelog = "https://github.com/thatmagicalcat/txm/releases/tag/v${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ DuskyElf ];
    mainProgram = "txm";
    platforms = lib.platforms.all;
  };
})
