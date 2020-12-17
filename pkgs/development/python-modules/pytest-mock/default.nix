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
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4d6d37329e4a893e77d9ffa89e838dd2b45d5dc099984cf03c703ac8411bb82";
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
