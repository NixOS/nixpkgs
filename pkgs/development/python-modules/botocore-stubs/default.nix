{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-awscrt,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "botocore-stubs";
  version = "1.43.114";
  pyproject = true;

  src = fetchPypi {
    pname = "botocore_stubs";
    inherit (finalAttrs) version;
    hash = "sha256-6I6dBheAF/p2QuRuzFmpeDhu9B5bTKNj2YjXL5JR13M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    types-awscrt
    typing-extensions
  ];

  pythonImportsCheck = [ "botocore-stubs" ];

  meta = {
    description = "Type annotations and code completion for botocore";
    homepage = "https://pypi.org/project/botocore-stubs/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
