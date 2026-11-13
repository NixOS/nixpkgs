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
  version = "1.13.0";
  pyproject = true;

  # Updates should be correlated with arrow-adbc top-level attribute, so:
  # nixpkgs-update: no auto update
  src = fetchPypi {
    pname = "adbc_driver_manager";
    inherit (finalAttrs) version;
    hash = "sha256-ctYW5D0DtzXkAAtlMwdTGi0YIPH34M6Ullbwq5Ob1T4=";
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
