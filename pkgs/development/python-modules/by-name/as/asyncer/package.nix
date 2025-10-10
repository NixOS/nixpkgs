{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  anyio,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "asyncer";
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastapi";
    repo = "asyncer";
    tag = version;
    hash = "sha256-1M5MGaxfEfJMCfAoGorNGbRBZdvLue5lHu8DuR96mLo=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    anyio
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asyncer" ];

  meta = {
    description = "Asyncer, async and await, focused on developer experience";
    homepage = "https://github.com/fastapi/asyncer";
    changelog = "https://github.com/fastapi/asyncer/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
  };
}
