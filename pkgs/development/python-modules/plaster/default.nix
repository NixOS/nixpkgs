{
  buildPythonPackage,
  fetchPypi,
  pytest,
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "plaster";
  version = "1.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+L78VL+MEUfBCrQCl+yEwmdvotTqXW9STZQ2qAB075g=";
  };

  checkPhase = ''
    py.test
  '';

  nativeCheckInputs = [
    pytest
    pytest-cov
  ];
}
