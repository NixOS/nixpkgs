{ stdenv
, python
, buildPythonPackage
, fetchPypi
, pytest
, python-utils
, sphinx
, flake8
, pytestpep8
, pytest-flakes
, pytestcov
, pytestcache
, pytestrunner
, freezegun
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "3.51.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ecf687696dd449067f69ef6730c4d4a0189db1f8d1aad9e376358354631d5b2c";
  };

  propagatedBuildInputs = [ python-utils ];
  nativeBuildInputs = [ pytestrunner ];
  checkInputs = [
    pytest sphinx flake8 pytestpep8 pytest-flakes pytestcov
    pytestcache freezegun
  ];
  # ignore tests on the nix wrapped setup.py and don't flake .eggs directory
  checkPhase = ''
    runHook preCheck
    ${python.interpreter} setup.py test --addopts "--ignore=.eggs"
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    homepage = "https://progressbar-2.readthedocs.io/en/latest/";
    description = "Text progressbar library for python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
