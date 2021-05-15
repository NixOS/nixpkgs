{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, bleach
, mt-940
, requests
, sepaxml
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  version = "3.0.1";
  pname = "fints";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-fints";
    rev = "v${version}";
    sha256 = "sha256-P9+3QuB5c7WMjic2fSp8pwXrOUHIrLThvfodtbBXLMY=";
  };

  propagatedBuildInputs = [ requests mt-940 sepaxml bleach ];

  checkInputs = [ pytestCheckHook pytest-mock ];

  meta = with lib; {
    homepage = "https://github.com/raphaelm/python-fints/";
    description = "Pure-python FinTS (formerly known as HBCI) implementation";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ elohmeier dotlambda ];
  };
}
