{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rzpipe";
  version = "0.1.2";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-va56xSWDIVtZ88QUzPfk8cCr28+5nZCNcSJMiVj3SZU=";
  };

  # No native rz_core library
  doCheck = false;

  pythonImportsCheck = [
    "rzpipe"
  ];

  meta = with lib; {
    description = "Python interface for rizin";
    homepage = "https://rizin.re";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
