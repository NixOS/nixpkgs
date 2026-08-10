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
  traitsui,
  vtk,
  wrapQtAppsHook,
}:

buildPythonPackage rec {
  pname = "mayavi";
  version = "4.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0Sz7Nipliw2Z8IgYSrttyoBdiszEN71egTHCIZh3g94=";
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

  # stripping the ico file on macos cause segfault
  stripExclude = [ "*.ico" ];

  meta = {
    description = "3D visualization of scientific data in Python";
    homepage = "https://github.com/enthought/mayavi";
    license = lib.licenses.bsdOriginal;
    maintainers = [ ];
    mainProgram = "mayavi2";
  };
}
