{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  # build inputs
  typing-extensions,
  typing-inspect,
}:
let
  pname = "pyre-extensions";
  version = "0.0.30";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-unkjxIbgia+zehBiOo9K6C1zz/QkJtcRxIrwcOW8MbI=";
  };

  propagatedBuildInputs = [
    typing-extensions
    typing-inspect
  ];

  pythonImportsCheck = [ "pyre_extensions" ];

  meta = with lib; {
    description = "This module defines extensions to the standard “typing” module that are supported by the Pyre typechecker";
    homepage = "https://pypi.org/project/pyre-extensions";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
