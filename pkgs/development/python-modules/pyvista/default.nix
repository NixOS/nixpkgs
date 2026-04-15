{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cyclopts,
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
  version = "0.47.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyvista";
    repo = "pyvista";
    tag = "v${version}";
    hash = "sha256-59Crx2YeCLUcmiFeBGa9yrefRgamW58OqGIO933zkJc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cyclopts
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
