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
, vtk
}:

buildPythonPackage rec {
  pname = "pyvista";
  version = "0.43.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-H7WkRK9lP92L47nFNDT1WusWfU0bLgXBA+KQqTyedL4=";
  };

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
