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
  version = "0.0.32";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "pyre_extensions"; # changed pname on 0.0.31?
    hash = "sha256-U5ZxXxTqVsTV/QqIxXyn5E+qRo+QWQnt195K2Q7YXlU=";
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
