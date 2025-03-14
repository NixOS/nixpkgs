{
  lib,
  buildPythonPackage,
  dvc-objects,
  fetchPypi,
  fsspec,
  pythonOlder,
  requests-kerberos,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dvc-webhdfs";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bolIQ9Fc52agXGFt7anZvDYSSOk7+eozi5lublHqD+o=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dvc-objects
    fsspec
  ];

  optional-dependencies = {
    kerberos = [ requests-kerberos ];
  };

  # Circular dependency
  # pythonImportsCheck = [ "dvc_webhdfs" ];

  meta = {
    description = "Webhdfs plugin for dvc";
    homepage = "https://pypi.org/project/dvc-webhdfs/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
