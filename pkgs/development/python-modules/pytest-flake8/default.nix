{lib, buildPythonPackage, fetchPypi, fetchpatch, pytest, flake8}:

buildPythonPackage rec {
  pname = "pytest-flake8";
  version = "1.0.0";

  # although pytest is a runtime dependency, do not add it as
  # propagatedBuildInputs in order to allow packages depend on another version
  # of pytest more easily
  buildInputs = [ pytest ];
  propagatedBuildInputs = [ flake8 ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "01driw4sc6nfi3m3ii7d074pxi3h1h4mbiyad9crg5i1l5jxx5ir";
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
