{
  lib,
  buildPythonPackage,
  fetchPypi,

  # extra: websocket
  websocket-client,
}:

buildPythonPackage rec {
  pname = "samsungctl";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L8F1+3MLOeuu1dldsXim2u7BuAIUawEW7RPnYpob/0Y=";
  };

  optional-dependencies = {
    websocket = [ websocket-client ];
    # interactive_ui requires curses package
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "samsungctl" ];

  meta = {
    description = "Remote control Samsung televisions via a TCP/IP connection";
    mainProgram = "samsungctl";
    homepage = "https://github.com/Ape/samsungctl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
