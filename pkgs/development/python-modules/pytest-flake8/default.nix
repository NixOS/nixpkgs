{lib, buildPythonPackage, fetchPypi, pytest, flake8}:

buildPythonPackage rec {
  pname = "pytest-flake8";
  version = "1.0.6";

  # although pytest is a runtime dependency, do not add it as
  # propagatedBuildInputs in order to allow packages depend on another version
  # of pytest more easily
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ flake8 ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b82bb58c88eb1db40524018d3fcfd0424575029703b4e2d8e3ee873f2b17027";
  };

  checkPhase = ''
    pytest .
  '';

  meta = {
    description = "py.test plugin for efficiently checking PEP8 compliance";
    homepage = "https://github.com/tholo/pytest-flake8";
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
