{ stdenv
, python
, buildPythonPackage
, fetchFromGitHub
, pytest
, python-utils
, sphinx
, coverage
, execnet
, flake8
, pytestpep8
, pytestflakes
, pytestcov
, pytestcache
, pep8
, pytestrunner
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "3.12.0";

  # Use source from GitHub, PyPI is missing tests
  # https://github.com/WoLpH/python-progressbar/issues/151
  src = fetchFromGitHub {
    owner = "WoLpH";
    repo = "python-progressbar";
    rev = "v${version}";
    sha256 = "1gk45sh8cd0kkyvzcvx95z6nlblmyx0x189mjfv3vfa43cr1mb0f";
  };

  propagatedBuildInputs = [ python-utils ];
  nativeBuildInputs = [ pytestrunner ];
  checkInputs = [
    pytest sphinx coverage execnet flake8 pytestpep8 pytestflakes pytestcov
    pytestcache pep8
  ];
  # ignore tests on the nix wrapped setup.py and don't flake .eggs directory
  checkPhase = ''
    runHook preCheck
    ${python.interpreter} setup.py test --addopts "--ignore=.eggs"
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    homepage = https://progressbar-2.readthedocs.io/en/latest/;
    description = "Text progressbar library for python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
