{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  websocket-client,
}:

buildPythonPackage (finalAttrs: {
  pname = "pychromedevtools";
  version = "1.0.4";
  __structuredAttrs = true;

  pyproject = true;

  src = fetchFromGitHub {
    owner = "marty90";
    repo = "PyChromeDevTools";
    tag = finalAttrs.version;
    hash = "sha256-oFv8kfIYP0iJlPyA3EulwB4z7z1kZ/1gOBEKsV+SUHY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    websocket-client
  ];

  pythonImportsCheck = [
    "PyChromeDevTools"
  ];

  meta = {
    description = "Python module that allows one to interact with Google Chrome using Chrome DevTools Protocol";
    homepage = "https://github.com/marty90/PyChromeDevTools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      haansn08
    ];
  };
})
