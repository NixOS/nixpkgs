{
  lib,
  apptools,
  buildPythonPackage,
  envisage,
  fetchPypi,
  numpy_1,
  packaging,
  pyface,
  pygments,
  pyqt5,
  pythonOlder,
  pythonAtLeast,
  stdenv,
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
    numpy_1
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
    maintainers = with maintainers; [ ];
    mainProgram = "mayavi2";
    # Fails during stripping with:
    # The file was not recognized as a valid object file
    broken = stdenv.hostPlatform.isDarwin;
  };
}
