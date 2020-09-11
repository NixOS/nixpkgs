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
  version = "3.51.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dnfw8mdrz78gck4ibnv64cinbp5f7kw349wjgpwv53z6p7jiwhk";
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
