{
  lib,
  buildPythonPackage,
  dvc-objects,
  fetchPypi,
  ossfs,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dvc-oss";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EEf3NAIvzSuW0ysGv24JIc0KZYEPf8HpsPrCmhR7apo=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  build-system = [ setuptools-scm ];

  dependencies = [
    dvc-objects
    ossfs
  ];

  # Circular dependency
  # pythonImportsCheck = [ "dvc_ssh" ];

  meta = {
    description = "Alibaba OSS plugin for dvc";
    homepage = "https://pypi.org/project/dvc-oss/";
    changelog = "https://github.com/iterative/dvc-oss/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
