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

  meta = with lib; {
    description = "Easier Pythonic interface to VTK";
    homepage = "https://pyvista.org";
    changelog = "https://github.com/pyvista/pyvista/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
