{ lib
, buildPythonPackage
, fetchFromGitHub
, imageio
, numpy
, pillow
, pooch
, scooby
, vtk
}:

buildPythonPackage rec {
  pname = "pyvista";
  version = "0.38.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7UK5vUlOleH24uJQ3WN8qVxWCfwlFYwhXTrS6Am7E+E=";
  };

  propagatedBuildInputs = [
    imageio
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
    homepage = "https://pyvista.org";
    description = "Easier Pythonic interface to VTK";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
