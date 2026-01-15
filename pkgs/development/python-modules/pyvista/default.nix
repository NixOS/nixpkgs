{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  numpy,
  pillow,
  pooch,
  scooby,
  setuptools,
  typing-extensions,
  vtk,
}:

buildPythonPackage rec {
  pname = "pyvista";
  version = "0.46.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyvista";
    repo = "pyvista";
    tag = "v${version}";
    hash = "sha256-FFrnLiGiP6LSwaoEHx4tih6XPdKCZ/9tjvz00NQDU0Q=";
  };

  patches = [
    # Fix Python 3.14 compatibility: Convert Union to | syntax and use TypeAlias
    # Based on https://github.com/pyvista/pyvista/pull/8102 which doesn't apply
    # to 0.46.4
    ./python314-compat.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    matplotlib
    numpy
    pillow
    pooch
    scooby
    typing-extensions
    vtk
  ];

  # Fatal Python error: Aborted
  doCheck = false;

  pythonImportsCheck = [ "pyvista" ];

  meta = {
    description = "Easier Pythonic interface to VTK";
    homepage = "https://pyvista.org";
    changelog = "https://github.com/pyvista/pyvista/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
