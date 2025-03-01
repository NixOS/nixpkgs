{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pdm-backend,
  anyio,
  typing-extensions,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "asyncer";
  version = "0.0.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fastapi";
    repo = "asyncer";
    tag = version;
    hash = "sha256-SbByOiTYzp+G+SvsDqXOQBAG6nigtBXiQmfGgfKRqvM=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    anyio
    typing-extensions
  ];

  pythonImportsCheck = [ "asyncer" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Asyncer, async and await, focused on developer experience";
    homepage = "https://github.com/fastapi/asyncer";
    changelog = "https://github.com/fastapi/asyncer/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
  };
}
