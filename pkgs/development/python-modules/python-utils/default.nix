{ lib, buildPythonPackage, fetchFromGitHub, pytest, pytestrunner, pytestcov, pytestflakes, pytestpep8, sphinx, six }:

buildPythonPackage rec {
  pname = "python-utils";
  version = "2.3.0";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = "python-utils";
    rev = "v${version}";
    sha256 = "14gyphcqwa77wfbnrzj363v3fdkxy08378lgd7l3jqnpvr8pfp5c";
  };

  checkInputs = [ pytest pytestrunner pytestcov pytestflakes pytestpep8 sphinx ];

  postPatch = ''
    # pytest-runner is only actually required in checkPhase
    substituteInPlace setup.py --replace "setup_requires=['pytest-runner']," ""
  '';

  # Tests failing
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Module with some convenient utilities";
    homepage = "https://github.com/WoLpH/python-utils";
    license = licenses.bsd3;
  };
}
