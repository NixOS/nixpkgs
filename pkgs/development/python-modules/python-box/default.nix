{ lib
, buildPythonPackage
, fetchFromGitHub
, msgpack
, pytestCheckHook
, pythonOlder
, pyyaml
, ruamel-yaml
, toml
}:

buildPythonPackage rec {
  pname = "python-box";
  version = "6.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "Box";
    rev = "refs/tags/${version}";
    hash = "sha256-42VDZ4aASFFWhRY3ApBQ4dq76eD1flZtxUM9hpA9iiI=";
  };

  propagatedBuildInputs = [
    msgpack
    pyyaml
    ruamel-yaml
    toml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "box"
  ];

  meta = with lib; {
    description = "Python dictionaries with advanced dot notation access";
    homepage = "https://github.com/cdgriffith/Box";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
