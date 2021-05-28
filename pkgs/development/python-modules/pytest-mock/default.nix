{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, isPy3k
, pytest
, mock
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7122d55505d5ed5a6f3df940ad174b3f606ecae5e9bc379569cdcbd4cd9d2b83";
  };

  propagatedBuildInputs = lib.optional (!isPy3k) mock;

  nativeBuildInputs = [
   setuptools_scm
  ];

  checkInputs = [
    pytest
  ];

  # ignore test which only works with pytest5 output structure
  checkPhase = ''
    pytest -k 'not detailed_introspection_async'
  '';

  meta = with lib; {
    description = "Thin-wrapper around the mock package for easier use with py.test.";
    homepage    = "https://github.com/pytest-dev/pytest-mock";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
