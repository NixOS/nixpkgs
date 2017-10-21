{ lib, buildPythonPackage, fetchFromGitHub, pytest, pytestrunner, pytestcov, pytestflakes, pytestpep8, sphinx, six }:

buildPythonPackage rec {
  name = "python-utils-${version}";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = "python-utils";
    rev = "v${version}";
    sha256 = "1i3q9frai08nvrcmh4dg4rr0grncm68w2c097z5g1mfwdf9sv7df";
  };

  checkInputs = [ pytest pytestrunner pytestcov pytestflakes pytestpep8 sphinx ];

  checkPhase = ''
    rm nix_run_setup.py
    py.test
  '';

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Module with some convenient utilities";
    homepage = "https://github.com/WoLpH/python-utils";
    license = licenses.bsd3;
  };
}
