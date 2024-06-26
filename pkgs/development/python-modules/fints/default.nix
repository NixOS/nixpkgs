{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  bleach,
  mt-940,
  requests,
  sepaxml,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  version = "4.0.0";
  pname = "fints";
  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-fints";
    rev = "v${version}";
    hash = "sha256-SREprcrIdeKVpL22IViexwiKmFfbT2UbKEmxtVm6iu0=";
  };

  propagatedBuildInputs = [
    requests
    mt-940
    sepaxml
    bleach
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = with lib; {
    homepage = "https://github.com/raphaelm/python-fints/";
    description = "Pure-python FinTS (formerly known as HBCI) implementation";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      dotlambda
    ];
  };
}
