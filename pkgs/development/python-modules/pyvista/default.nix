{ lib
, buildPythonPackage
, fetchFromGitHub
, imageio
, matplotlib
, numpy
, pillow
, pooch
, scooby
, vtk
}:

buildPythonPackage rec {
  pname = "pyvista";
  version = "0.42.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ujuDH+GK9Q6V8r/PgU5Lu3P7cmau/n7Rk/8a+v7/JRo=";
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
    homepage = "https://pyvista.org";
    description = "Easier Pythonic interface to VTK";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
