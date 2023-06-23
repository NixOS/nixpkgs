{ lib
, bleak
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "aranet4";
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Anrijs";
    repo = "Aranet4-Python";
    rev = "refs/tags/v${version}";
    hash = "sha256-u2KLs+j8MvJhyX8rpMjd1uwPSD8hkCbhOL7Y/FqbwTM=";
  };

  propagatedBuildInputs = [
    bleak
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aranet4"
  ];

  disabledTests = [
    # Test compares rendered output
    "test_current_values"
  ];

  meta = with lib; {
    description = "Module to interact with Aranet4 devices";
    homepage = "https://github.com/Anrijs/Aranet4-Python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
