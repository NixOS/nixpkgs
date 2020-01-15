{lib, buildPythonPackage, fetchPypi, pytest, flake8}:

buildPythonPackage rec {
  pname = "pytest-flake8";
  version = "1.0.4";

  # although pytest is a runtime dependency, do not add it as
  # propagatedBuildInputs in order to allow packages depend on another version
  # of pytest more easily
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ flake8 ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d225c13e787471502ff94409dcf6f7927049b2ec251c63b764a4b17447b60c0";
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
