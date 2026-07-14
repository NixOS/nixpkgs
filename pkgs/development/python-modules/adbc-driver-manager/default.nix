{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  cython,
  setuptools,

  # dependencies
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "adbc-driver-manager";
  version = "1.11.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "adbc_driver_manager";
    inherit (finalAttrs) version;
    hash = "sha256-xkqqvrWBAQmrPSlhAI8bAU6fLYez30QWwqCApAI3r1A=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    typing-extensions
  ];

  # Tests create a circular dependency on adbc-driver-sqlite
  doCheck = false;

  pythonImportsCheck = [
    "adbc_driver_manager"
  ];

  meta = {
    description = "A generic entrypoint for ADBC drivers";
    homepage = "https://pypi.org/project/adbc-driver-manager";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
