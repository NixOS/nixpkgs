{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "linetable";
  version = "0.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "amol-";
    repo = "linetable";
    rev = "refs/tags/${version}";
    hash = "sha256-nVZVxK6uB5TP0pReaEya3/lFXFkiqpnnaWqYzxzO6bM=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "linetable"
  ];

  meta = with lib; {
    description = "Library to parse and generate co_linetable attributes in Python code objects";
    homepage = "https://github.com/amol-/linetable";
    changelog = "https://github.com/amol-/linetable/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
