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
  version = "0.0.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastapi";
    repo = "asyncer";
    tag = version;
    hash = "sha256-4h6s0jsAzTT6LbsvfQGkc7qNCcPgoyR9Qr/yro1ukbg=";
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
