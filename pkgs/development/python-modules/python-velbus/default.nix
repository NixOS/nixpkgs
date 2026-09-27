{
  lib,
  buildPythonPackage,
  fetchPypi,
  pkg-resources-backport,
  pyserial,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-velbus";
  version = "2.1.14";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-3eDfXPMO167QI/umLBjlHTBV67XQ8QYkg4EzfrRTw6M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pkg-resources-backport
    pyserial
  ];

  # Project has not tests
  doCheck = false;

  pythonImportsCheck = [ "velbus" ];

  meta = {
    description = "Python library to control the Velbus home automation system";
    homepage = "https://github.com/thomasdelaet/python-velbus";
    changelog = "https://github.com/thomasdelaet/python-velbus/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
