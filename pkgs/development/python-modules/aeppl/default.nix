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
  version = "0.0.39";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aesara-devs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ILyE3tqoDHNmrKpHPBUJ02jrGevsU5864rjhgmgjwvo=";
  };

  propagatedBuildInputs = [
    aesara
    numpy
    scipy
  ];

  checkInputs = [
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
