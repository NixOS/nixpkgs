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
  version = "1.5.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "griffe";
    tag = version;
    hash = "sha256-TQSQ+gW79GV3lkdPAYsJb2stvVY4CktjjS3yO7S8o2E=";
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
    changelog = "https://github.com/mkdocstrings/griffe/blob/${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
    mainProgram = "griffe";
  };
}
