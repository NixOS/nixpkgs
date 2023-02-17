{ lib
, apptools
, buildPythonPackage
, envisage
, fetchPypi
, numpy
, packaging
, pyface
, pygments
, pyqt5
, pythonOlder
, traitsui
, vtk
, wrapQtAppsHook
}:

buildPythonPackage rec {
  pname = "mayavi";
  version = "4.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-n0J+8spska542S02ibpr7KJMhGDicG2KHJuEKJrT/Z4=";
  };

  postPatch = ''
    # building the docs fails with the usual Qt xcb error, so skip:
    substituteInPlace setup.py \
      --replace "build.build.run(self)" "build.build.run(self); return"
  '';

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    apptools
    envisage
    numpy
    packaging
    pyface
    pygments
    pyqt5
    traitsui
    vtk
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  # Needs X server
  doCheck = false;

  pythonImportsCheck = [
    "mayavi"
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "3D visualization of scientific data in Python";
    homepage = "https://github.com/enthought/mayavi";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
