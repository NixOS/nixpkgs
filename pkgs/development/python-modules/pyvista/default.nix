{ lib
, buildPythonPackage
, fetchFromGitHub
, imageio
, matplotlib
, numpy
, pillow
, pooch
, pythonOlder
, scooby
, setuptools
, vtk
}:

buildPythonPackage rec {
  pname = "pyvista";
  version = "0.43.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-EhhnX7r8yHynEVahMSB6LxCAquQcUF4cI0S4oW+IZ/Y=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    imageio
    matplotlib
    numpy
    pillow
    pooch
    scooby
    vtk
  ];

  # Fatal Python error: Aborted
  doCheck = false;

  pythonImportsCheck = [
    "pyvista"
  ];

  meta = with lib; {
    description = "Easier Pythonic interface to VTK";
    homepage = "https://pyvista.org";
    changelog = "https://github.com/pyvista/pyvista/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
