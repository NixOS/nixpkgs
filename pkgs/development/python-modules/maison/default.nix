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
  version = "1.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dbatten5";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Ny/n1vDWS6eA9zLIB0os5zrbwvutb+7sQ6iPXeid1M0=";
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
