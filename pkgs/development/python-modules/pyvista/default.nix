{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  numpy,
  pillow,
  pooch,
  pythonOlder,
  scooby,
  setuptools,
  typing-extensions,
  vtk,
}:

buildPythonPackage rec {
  pname = "pyvista";
  version = "0.44.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyvista";
    repo = "pyvista";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZQfI0lmh/cwE224yk6a2G3gLUCsBjCQqPI1y4zYj0FI=";
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
    changelog = "https://github.com/pyvista/pyvista/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
