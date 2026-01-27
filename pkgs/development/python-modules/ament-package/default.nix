{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  importlib-metadata,
  importlib-resources,
}:

buildPythonPackage rec {
  pname = "ament-package";
  version = "0.16.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ament";
    repo = "ament_package";
    tag = version;
    hash = "sha256-DPW6XMQr6W5340oAilmfMswaPdMInCZ2tsQ/ayM3Xlk=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    importlib-metadata
    importlib-resources
  ];

  pythonImportsCheck = [ "ament_package" ];

  # Tests currently broken
  doCheck = false;

  meta = {
    description = "Parser for the manifest files in the ament buildsystem";
    homepage = "https://github.com/ament/ament_package";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
