{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-mimeparse";
  version = "1.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-duSwPXAKZB/Xdh081P273NeH6t4ev6xD+HcBYygzT3g=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Module provides basic functions for parsing mime-type names and matching them against a list of media-ranges";
    homepage = "https://github.com/dbtsai/python-mimeparse";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
