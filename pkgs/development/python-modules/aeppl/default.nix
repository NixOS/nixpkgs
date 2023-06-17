{ lib
, aesara
, buildPythonPackage
, fetchFromGitHub
, numdifftools
, numpy
, pytestCheckHook
, pythonOlder
, scipy
}:

buildPythonPackage rec {
  pname = "aeppl";
  version = "0.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aesara-devs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-y2JQxHztLEORoqVikOD/pSF5+WJRo/f8XyZKVDx2Ybs=";
  };

  propagatedBuildInputs = [
    aesara
    numpy
    scipy
  ];

  nativeCheckInputs = [
    numdifftools
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    "aeppl"
  ];

  disabledTests = [
    # Compute issue
    "test_initial_values"
  ];

  meta = with lib; {
    description = "Library for an Aesara-based PPL";
    homepage = "https://github.com/aesara-devs/aeppl";
    changelog = "https://github.com/aesara-devs/aeppl/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
