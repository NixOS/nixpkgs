{ buildPythonPackage, fetchPypi
, pytest, pytest-cov
}:

buildPythonPackage rec {
  pname = "plaster";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+L78VL+MEUfBCrQCl+yEwmdvotTqXW9STZQ2qAB075g=";
  };

  checkPhase = ''
    py.test
  '';

  checkInputs = [ pytest pytest-cov ];
}
