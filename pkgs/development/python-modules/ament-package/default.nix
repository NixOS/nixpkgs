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
<<<<<<< HEAD
  version = "0.18.2";
=======
  version = "0.18.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ament";
    repo = "ament_package";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-m0tDgbjytBKhdqZrSmhKHRm69BZK54NHWmo+O5J8m6Q=";
=======
    hash = "sha256-M2SSGmzxlOITNzWTZ92/PtTVGtKMU/IwJG0VMhzDLR8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
