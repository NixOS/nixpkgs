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
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b35eb281e93aafed138db25c8772b95d3756108b601947f89af503f8c629413f";
  };

  propagatedBuildInputs = lib.optional (!isPy3k) mock;

  nativeBuildInputs = [
   setuptools_scm
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Thin-wrapper around the mock package for easier use with py.test.";
    homepage    = "https://github.com/pytest-dev/pytest-mock";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
