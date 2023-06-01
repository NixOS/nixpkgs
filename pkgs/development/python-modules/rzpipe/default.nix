{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rzpipe";
  version = "0.5.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kEJg619HyX7loEBUsjpVtgF5dBzJtmM9/bQnUkDUjHU=";
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
