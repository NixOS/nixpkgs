{
  lib,
  apptools,
  buildPythonPackage,
  envisage,
  fetchPypi,
  numpy,
  packaging,
  pyface,
  pygments,
  pyqt5,
  pythonOlder,
  pythonAtLeast,
  traitsui,
  vtk,
  wrapQtAppsHook,
}:

buildPythonPackage rec {
  pname = "mayavi";
  version = "4.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sQ/pFF8hxI5JAvDnRrNgOzy2lNEUVlFaRoIPIaCnQik=";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];

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

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  # Needs X server
  doCheck = false;

  pythonImportsCheck = [ "mayavi" ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "3D visualization of scientific data in Python";
    homepage = "https://github.com/enthought/mayavi";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ knedlsepp ];
    mainProgram = "mayavi2";
  };
}
