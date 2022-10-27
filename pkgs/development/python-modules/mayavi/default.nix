{ lib
, apptools
, buildPythonPackage
, envisage
, fetchPypi
, numpy
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
  version = "4.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TGBDYdn1+juBvhjVvxTzBlCw7jju1buhbMikQ5QXj2M=";
  };

  postPatch = ''
    # Discovery of 'vtk' in setuptools is not working properly, due to a missing
    # .egg-info in the vtk package. It does however import and run just fine.
    substituteInPlace mayavi/__init__.py --replace "'vtk'" ""

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
    pyface
    pygments
    pyqt5
    traitsui
    vtk
  ];

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
