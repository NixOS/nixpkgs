{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  lxml,
}:

buildPythonPackage {
  pname = "cmsis-svd";
  version = "0.4-unstable-2024-01-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cmsis-svd";
    repo = "cmsis-svd";
    rev = "38d21d30abd0d4c2f34fd79d83b34392ed4bb7a3";
    hash = "sha256-lFA0sNHVj4a4+EwOTmFUbM/nhmzJ4mx4GvT6Ykutakk=";
  };

  preBuild = ''
    cd python
  '';

  build-system = [ setuptools ];

  dependencies = [
    six
    lxml
  ];

  pythonImportsCheck = [
    "cmsis_svd"
    "cmsis_svd.parser"
  ];

  meta = {
    description = "CMSIS SVD parser";
    homepage = "https://github.com/cmsis-svd/cmsis-svd";
    maintainers = [ lib.maintainers.dump_stack ];
    license = lib.licenses.asl20;
  };
}
