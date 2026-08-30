{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  typing-extensions,
}:
buildPythonPackage (finalAttrs: {
  pname = "aiodataloader";
  version = "0.4.3";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "syrusakbary";
    repo = "aiodataloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7UynuXbO0fmcEznaO+0gSx2VcigneZXWOIFaKGklR3s=";
  };
  dependencies = [ typing-extensions ];
  build-system = [ hatchling ];
  meta = {
    description = "Asyncio DataLoader implementation for Python";
    homepage = "https://github.com/syrusakbary/aiodataloader";
    changelog = "https://github.com/syrusakbary/aiodataloader/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
