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
    sha256 = "sha256-epNUWne1P/QJjSyXaMxUIrVKyMMXl9uWFgukiJTbHGg=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cython ];

  pythonImportsCheck = [ "FXrays" ];

  meta = with lib; {
    description = "Computes extremal rays of polyhedral cones with filtering";
    homepage = "https://github.com/3-manifolds/FXrays";
    license = licenses.gpl2;
    maintainers = with maintainers; [ noiioiu ];
  };
}
