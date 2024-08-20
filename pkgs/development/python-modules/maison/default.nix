{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  toml,
}:

buildPythonPackage rec {
  pname = "maison";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dbatten5";
    repo = "maison";
    rev = "refs/tags/v${version}";
    hash = "sha256-1hsnSYDoCO5swWm3B4R5eXs0Mn4s8arlCQKfsS1OWRk=";
  };

  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    click
    toml
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "maison" ];

  meta = with lib; {
    description = "Library to read settings from config files";
    mainProgram = "maison";
    homepage = "https://github.com/dbatten5/maison";
    changelog = "https://github.com/dbatten5/maison/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
