{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
}:

buildPythonPackage {
  pname = "fxrays";
  version = "1.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "FXrays";
    # release of version 1.3.6
    rev = "f02aaab228972044ca4e39fa55fdd46b3768900e";
    hash = "sha256-IwEY54zDXqMci7WRvhueDJidTsbMwv6eqQSGZzFOtnQ";
  };

  build-system = [
    setuptools
    cython
  ];

  pythonImportsCheck = [ "FXrays" ];

  meta = with lib; {
    description = "Computes extremal rays of polyhedral cones with filtering";
    homepage = "https://github.com/3-manifolds/FXrays";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ noiioiu ];
  };
}
