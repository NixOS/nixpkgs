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
  version = "1.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dbatten5";
    repo = "maison";
    rev = "refs/tags/v${version}";
    hash = "sha256-XNo7QS8BCYzkDozLW0T+KMQPI667lDTCFtOqKq9q3hw=";
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
