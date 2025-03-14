{
  lib,
  aiofiles,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  git,
  jsonschema,
  mkdocstrings,
  pdm-backend,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "griffe";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "griffe";
    tag = version;
    hash = "sha256-Cs3qJlF1k1cKmbH7bXkn8+XDRC0sZqVdrMPIw0dSWD8=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    colorama
    mkdocstrings
  ];

  nativeCheckInputs = [
    git
    jsonschema
    pytestCheckHook
  ];

  optional-dependencies = {
    async = [ aiofiles ];
  };

  pythonImportsCheck = [ "griffe" ];

  meta = with lib; {
    description = "Signatures for entire Python programs";
    homepage = "https://github.com/mkdocstrings/griffe";
    changelog = "https://github.com/mkdocstrings/griffe/blob/${src.tag}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
    mainProgram = "griffe";
  };
}
