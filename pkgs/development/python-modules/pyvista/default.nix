{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  numpy,
  pillow,
  pooch,
  pythonAtLeast,
  scooby,
  setuptools,
  typing-extensions,
  vtk,
}:

buildPythonPackage rec {
  pname = "pyvista";
  version = "0.46.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyvista";
    repo = "pyvista";
    tag = "v${version}";
    hash = "sha256-o/g2cvSCLwKigHxMinS1WeVLj6Z6RGM3F/3kWURTJks=";
  };

  # remove this line once pyvista 0.46 is released
  pythonRelaxDeps = [ "vtk" ];

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
