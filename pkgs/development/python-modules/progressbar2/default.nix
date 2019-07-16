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
  version = "3.42.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a26r022lvz0vvwvhq2rfyl6h0hxbayvgbnajpnc0fc8f4gzr1n0";
  };

  postPatch = ''
    rm -r tests/__pycache__
    rm tests/*.pyc
  '';

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
    homepage = https://progressbar-2.readthedocs.io/en/latest/;
    description = "Text progressbar library for python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
