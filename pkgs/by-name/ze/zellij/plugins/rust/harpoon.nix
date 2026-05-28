{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "harpoon";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Nacho114";
    repo = "harpoon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JmYcbzxIF6qZs2/RKuspHqNpyDibGp9CVQJj47y/BOQ=";
  };

  cargoHash = "sha256-lsv5Wssakni18jif++fPo3Z5WyBtvPsGpWwG3abR7jQ=";

  meta = {
    description = "Quickly navigate your panes (clone of nvim's harpoon)";
    homepage = "https://github.com/Nacho114/harpoon";
    changelog = "https://github.com/Nacho114/harpoon/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
  };
})
