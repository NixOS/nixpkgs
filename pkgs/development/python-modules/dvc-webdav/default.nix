{
  lib,
  buildPythonPackage,
  dvc-objects,
  fetchPypi,
  setuptools-scm,
  setuptools,
  webdav4,
}:

buildPythonPackage (finalAttrs: {
  pname = "dvc-webdav";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "dvc_webdav";
    inherit (finalAttrs) version;
    hash = "sha256-PA0Er7CYWiwVbwtxn0uUN85KzTRmR9j2/uBDtekXx24";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dvc-objects
    webdav4
  ];

  # Circular dependency
  # pythonImportsCheck = [ "dvc_webdav" ];

  meta = {
    description = "Webdav plugin for dvc";
    homepage = "https://pypi.org/project/dvc-webdav/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
