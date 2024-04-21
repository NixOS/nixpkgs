{
  lib,
  aiofiles,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  git,
  jsonschema,
  pdm-backend,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "griffe";
  version = "0.42.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "griffe";
    rev = "refs/tags/${version}";
    hash = "sha256-W6aOhz8UxJUc2kNRc4JaCqFgIOXsY8ctyQ3xZ+YaD9k=";
  };

  build-system = [ pdm-backend ];

  dependencies = [ colorama ];

  nativeCheckInputs = [
    git
    jsonschema
    pytestCheckHook
  ];

  passthru.optional-dependencies = {
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
