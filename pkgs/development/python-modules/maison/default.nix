{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  loguru,
  platformdirs,
  pydantic,
  pytestCheckHook,
  setuptools,
  typer,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "maison";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbatten5";
    repo = "maison";
    tag = "v${version}";
    hash = "sha256-F0mxOeLFDCiPhhKaaUy4qV//Pb2JXCtOLNB1uW2KWZY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    loguru
    platformdirs
    typer
    typing-extensions
  ];

  checkInputs = [
    pydantic
    pytestCheckHook
  ];

  pythonImportsCheck = [ "maison" ];

  meta = with lib; {
    description = "Library to read settings from config files";
    homepage = "https://github.com/dbatten5/maison";
    changelog = "https://github.com/dbatten5/maison/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "maison";
  };
}
