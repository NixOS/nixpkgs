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
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "636e792f7dd9e2c80657e174c04bf7aa92672350090736d82e97e92ce8f68737";
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
