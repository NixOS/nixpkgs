{ lib
, buildPythonPackage
, docutils
, fetchPypi
, pybtex
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pybtex-docutils";
  version = "1.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q6o1O21Jj9WsMPAHOpjjMtBh00/mGdPVDRdh+P1KoBY=";
  };

  buildInputs = [
    docutils
    pybtex
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pybtex_docutils"
  ];

  meta = with lib; {
    description = "A docutils backend for pybtex";
    homepage = "https://github.com/mcmtroffaes/pybtex-docutils";
    license = licenses.mit;
  };
}
