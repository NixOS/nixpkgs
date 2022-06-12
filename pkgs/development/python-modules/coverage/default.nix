{ lib
, buildPythonPackage
, fetchPypi
, mock
, pythonOlder
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "6.3.2";
  # uses f strings
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-A+KngmCGuR7zRf8YdC7p/Eemg5zNUXBh74+hl25lLOk=";
  };

  # No tests in archive
  doCheck = false;
  checkInputs = [ mock ];

  meta = {
    description = "Code coverage measurement for python";
    homepage = "https://coverage.readthedocs.io/";
    license = lib.licenses.bsd3;
  };
}
