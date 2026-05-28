{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij-choose-tree";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "laperlej";
    repo = "zellij-choose-tree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g6R+LfSN7IgRPWr7sf3mLIn6c2xP/oaFO/MsxX7oB0s=";
  };

  cargoHash = "sha256-CPw+9dnlJi/5CFZNlYu3DTHvku5p8dAYh48awQ20ncs=";

  meta = {
    description = "Quickly switch between sessions";
    homepage = "https://github.com/laperlej/zellij-choose-tree";
    changelog = "https://github.com/laperlej/zellij-choose-tree/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
  };
})
