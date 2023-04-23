{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, bleach
, mt-940
, requests
, sepaxml
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  version = "3.1.0";
  pname = "fints";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-fints";
    rev = "v${version}";
    hash = "sha256-3frJIEZgVnZD2spWYIuEtUt7MVsU/Zj82HOB9fKYQWE=";
  };

  propagatedBuildInputs = [ requests mt-940 sepaxml bleach ];

  nativeCheckInputs = [ pytestCheckHook pytest-mock ];

  meta = with lib; {
    homepage = "https://github.com/raphaelm/python-fints/";
    description = "Pure-python FinTS (formerly known as HBCI) implementation";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ elohmeier dotlambda ];
  };
}
