{ lib
, buildPythonPackage
, fetchPypi
, mock
, pythonOlder
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "7.3.1";
  # uses f strings
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bLf+FYHetnt4LBUxNlQeIJAaoxLO7a8UZ9yzUlV4eVI=";
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
