{ lib
, buildPythonPackage
, fetchPypi
, mock
, pythonOlder
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "7.2.1";
  # uses f strings
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x38qkJPM8yndUjqbKzyFTCDSo9lott7zuCAnLKZzIkI=";
  };

  # No tests in archive
  doCheck = false;
  nativeCheckInputs = [ mock ];

  meta = {
    description = "Code coverage measurement for python";
    homepage = "https://coverage.readthedocs.io/";
    license = lib.licenses.bsd3;
  };
}
