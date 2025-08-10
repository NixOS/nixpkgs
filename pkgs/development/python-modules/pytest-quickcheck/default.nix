{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  pytestCheckHook,
  pytest-flakes,
}:

buildPythonPackage rec {
  pname = "pytest-quickcheck";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UFF8ldnaImXU6al4kGjf720mbwXE6Nut9VlvNVrMVoY=";
  };

  propagatedBuildInputs = [ pytest ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-flakes
  ];

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://pypi.python.org/pypi/pytest-quickcheck";
    description = "Pytest plugin to generate random data inspired by QuickCheck";
    maintainers = with maintainers; [ onny ];
  };
}
