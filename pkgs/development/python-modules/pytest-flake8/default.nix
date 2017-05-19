{lib, buildPythonPackage, fetchPypi, pytest, flake8}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pytest-flake8";
  version = "0.8.1";

  # although pytest is a runtime dependency, do not add it as
  # propagatedBuildInputs in order to allow packages depend on another version
  # of pytest more easily
  buildInputs = [ pytest ];
  propagatedBuildInputs = [ flake8 ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1za5i09gz127yraigmcl443w6149714l279rmlfxg1bl2kdsc45a";
  };

  checkPhase = ''
    pytest --ignore=nix_run_setup.py .
  '';

  meta = {
    description = "py.test plugin for efficiently checking PEP8 compliance";
    homepage = https://github.com/tholo/pytest-flake8;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
