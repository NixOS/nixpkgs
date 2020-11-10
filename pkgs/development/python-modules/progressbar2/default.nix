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
  version = "3.53.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef72be284e7f2b61ac0894b44165926f13f5d995b2bf3cd8a8dedc6224b255a7";
  };

  propagatedBuildInputs = [ python-utils ];
  nativeBuildInputs = [ pytestrunner ];
  checkInputs = [
    pytest sphinx flake8 pytestpep8 pytest-flakes pytestcov
    pytestcache freezegun
  ];
  # ignore tests on the nix wrapped setup.py
  checkPhase = ''
    runHook preCheck
    ${python.interpreter} setup.py test
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    homepage = "https://progressbar-2.readthedocs.io/en/latest/";
    description = "Text progressbar library for python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman turion ];
  };
}
