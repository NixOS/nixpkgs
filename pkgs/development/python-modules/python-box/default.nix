{ lib
, buildPythonPackage
, fetchFromGitHub
, msgpack
, pytestCheckHook
, pythonOlder
, pyyaml
, ruamel_yaml
, toml
}:

buildPythonPackage rec {
  pname = "python-box";
  version = "5.4.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "Box";
    rev = version;
    sha256 = "sha256-SkteajcWG7rBFMm6Xp6QCfkZfwthRituGL/RtICbtYk=";
  };

  propagatedBuildInputs = [
    msgpack
    pyyaml
    ruamel_yaml
    toml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "box" ];

  meta = with lib; {
    description = "Python dictionaries with advanced dot notation access";
    homepage = "https://github.com/cdgriffith/Box";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
