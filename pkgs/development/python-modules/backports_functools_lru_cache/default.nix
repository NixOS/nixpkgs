{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, isPy3k
, pytest
, pytest-black
, pytest-flake8
, pytestcov
}:

buildPythonPackage rec {
  pname = "backports.functools_lru_cache";
  version = "1.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d84e126e2a29e4fde8931ff8131240bbf30a0e7dbcc3897a8dbd8ea5ac11419c";
  };

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [ pytest pytest-flake8 pytest-black pytestcov ];
  # ironically, they fail a linting test, and pytest.ini forces that test suite
  checkPhase = ''
    rm backports/functools_lru_cache.py
    pytest -k 'not format'
  '';

  # Test fail on Python 2
  doCheck = isPy3k;

  meta = {
    description = "Backport of functools.lru_cache";
    homepage = "https://github.com/jaraco/backports.functools_lru_cache";
    license = lib.licenses.mit;
  };
}
