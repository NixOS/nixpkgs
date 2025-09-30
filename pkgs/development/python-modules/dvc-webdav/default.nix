{
  lib,
  buildPythonPackage,
  dvc-objects,
  fetchPypi,
  pythonOlder,
  setuptools-scm,
  setuptools,
  webdav4,
}:

buildPythonPackage rec {
  pname = "dvc-webdav";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Zefu8uvINBWo3b3LV5vyGaN5fGfnpi1FaMXILeK2pQg=";
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
}
