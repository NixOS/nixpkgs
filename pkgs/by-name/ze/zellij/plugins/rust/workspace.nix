{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij-workspace";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "vdbulcke";
    repo = "zellij-workspace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EMUZl5sxdJ/kNMdREpKmXRIxKd13P0Qb/oQ/eNmN3hI=";
  };

  cargoHash = "sha256-EkPwtJ134yfzVDVXp4uXjzyhFetp6TC10DSePua/g1k=";

  meta = {
    description = "Zellij plugin for applying layouts to current zellij session";
    homepage = "https://github.com/vdbulcke/zellij-workspace";
    changelog = "https://github.com/vdbulcke/zellij-workspace/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilkecan ];
  };
})
