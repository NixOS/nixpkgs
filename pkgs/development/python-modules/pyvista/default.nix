{ lib
, buildPythonPackage
, fetchPypi
, imageio
, numpy
, pillow
, pooch
, scooby
, vtk
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "pyvista";
  version = "0.37.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-02osbV9T9HOrapJBZpaTrO56UXk5Tcl1ldoUzB3iMUE=";
  };

  propagatedBuildInputs = [
    imageio
    numpy
    pillow
    pooch
    scooby
    vtk
  ];

  checkInputs = [
    unittestCheckHook
  ];

  meta = with lib; {
    homepage = "https://pyvista.org";
    description = "Easier Pythonic interface to VTK";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
