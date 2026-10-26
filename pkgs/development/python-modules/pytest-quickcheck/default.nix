{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  pytestCheckHook,
  pytest-flakes,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-quickcheck";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-UFF8ldnaImXU6al4kGjf720mbwXE6Nut9VlvNVrMVoY=";
  };

  propagatedBuildInputs = [ pytest ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-flakes
  ];

  meta = {
    license = lib.licenses.asl20;
    homepage = "https://pypi.org/project/pytest-quickcheck/";
    description = "Pytest plugin to generate random data inspired by QuickCheck";
    maintainers = with lib.maintainers; [ onny ];
  };
})
