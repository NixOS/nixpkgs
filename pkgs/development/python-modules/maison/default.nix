{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, poetry-core
, pydantic
, pytestCheckHook
, pythonOlder
, toml
}:

buildPythonPackage rec {
  pname = "maison";
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dbatten5";
    repo = "maison";
    rev = "refs/tags/v${version}";
    hash = "sha256-uJW+7+cIt+jnbiC+HvT7KzyNk1enEtELTxtfc4eXAPU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
    pydantic
    toml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "maison"
  ];

  meta = with lib; {
    description = "Library to read settings from config files";
    homepage = "https://github.com/dbatten5/maison";
    changelog = "https://github.com/dbatten5/maison/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
