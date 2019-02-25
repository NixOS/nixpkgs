{lib, buildPythonPackage, fetchPypi, pytest, flake8}:

buildPythonPackage rec {
  pname = "pytest-flake8";
  version = "1.0.3";

  # although pytest is a runtime dependency, do not add it as
  # propagatedBuildInputs in order to allow packages depend on another version
  # of pytest more easily
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ flake8 ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2c71fb6d469bae076a01c43d4a83485d740db6a8a00bad77e0657ed035e98d4";
  };

  checkPhase = ''
    pytest .
  '';

  meta = {
    description = "py.test plugin for efficiently checking PEP8 compliance";
    homepage = https://github.com/tholo/pytest-flake8;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
