{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mortgage";
  version = "1.0.5";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256:18fcb356c631e9cc27fa7019f6ff6021707e34b9ce3a3b7dc815661288709921";
  };

  checkInputs = [
    pytestCheckHook
  ];

  doCheck = false; # No tests in sdist

  disabled = pythonOlder "3.5";

  meta = {
    description = "Mortgage calculator";
    license = lib.licenses.mit;
  };

}