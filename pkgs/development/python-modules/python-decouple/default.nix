{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-decouple";
  version = "3.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "HBNetwork";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Ll0MZb4FaNFF/jvCfj4TkuoAi4m448KaOU3ykvKPbSo=";
  };

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "decouple"
  ];

  meta = with lib; {
    description = "Module to handle code and condifuration";
    homepage = "https://github.com/HBNetwork/python-decouple";
    changelog = "https://github.com/HBNetwork/python-decouple/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
