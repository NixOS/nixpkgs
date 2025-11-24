{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  requests-toolbelt,
  setuptools,
  pycryptodome,
  websockets,
  protobuf3,
  httpx,
}:

buildPythonPackage rec {
  pname = "lark-oapi";
  version = "1.3.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jhis9H7z94KCJy2EM79Hy44ouDnmSIXirJ7fOCZA2G8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    requests-toolbelt
    pycryptodome
    websockets
    protobuf3
    httpx
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "lark_oapi" ];

  meta = {
    homepage = "https://github.com/larksuite/oapi-sdk-python";
    description = "Larksuite development interface SDK";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yoctocell ];
  };
}
