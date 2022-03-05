{ lib
, buildPythonPackage
, fetchPypi
, mock
, pythonOlder
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "6.2";
  # uses f strings
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2cad8093172b7d1595b4ad66f24270808658e11acf43a8f95b41276162eb5b8";
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
