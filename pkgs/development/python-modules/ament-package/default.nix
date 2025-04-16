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
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ament";
    repo = "ament_package";
    tag = version;
    hash = "sha256-hwDHnx17pCL6oTRP5xuiQkFPp5XnwsXIcuUfuvcrMRw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    importlib-metadata
    importlib-resources
  ];

  pythonImportsCheck = [ "ament_package" ];

  meta = {
    description = "The parser for the manifest files in the ament buildsystem";
    homepage = "https://github.com/ament/ament_package";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
