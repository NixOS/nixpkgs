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
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8fde5f188da2d593bd5bc0be98d9abc46c95bb8a9dde93429570192ee6cc2d4a";
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
    homepage = https://github.com/jaraco/backports.functools_lru_cache;
    license = lib.licenses.mit;
  };
}
