{lib, buildPythonPackage, fetchPypi, pytest, flake8}:

buildPythonPackage rec {
  pname = "pytest-flake8";
  version = "1.0.7";

  # although pytest is a runtime dependency, do not add it as
  # propagatedBuildInputs in order to allow packages depend on another version
  # of pytest more easily
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ flake8 ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0259761a903563f33d6f099914afef339c085085e643bee8343eb323b32dd6b";
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
