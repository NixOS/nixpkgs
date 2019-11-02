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
  version = "1.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04fgqm06vkg3k1ngha65g1k5a80x1g7pr11s78j2d72rj4w2ql7a";
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
    homepage    = https://github.com/pytest-dev/pytest-mock;
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
