{
  lib,
  apptools,
  buildPythonPackage,
  envisage,
  fetchPypi,
  fetchpatch,
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
  # TODO: Remove meta.broken on next release.
  version = "4.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n0J+8spska542S02ibpr7KJMhGDicG2KHJuEKJrT/Z4=";
  };

  patches = [
    # Adds compatibility with Python 3.11.
    # https://github.com/enthought/mayavi/pull/1199
    (fetchpatch {
      name = "python311-compat.patch";
      url = "https://github.com/enthought/mayavi/commit/50c0cbfcf97560be69c84b7c924635a558ebf92f.patch";
      hash = "sha256-zZOT6on/f5cEjnDBrNGog/wPQh7rBkaFqrxkBYDUQu0=";
      includes = [ "tvtk/src/*" ];
    })
    # Fixes an incompatible function pointer conversion error
    # https://github.com/enthought/mayavi/pull/1266
    (fetchpatch {
      name = "incompatible-pointer-conversion.patch";
      url = "https://github.com/enthought/mayavi/commit/887adc8fe2b076a368070f5b1d564745b03b1964.patch";
      hash = "sha256-88H1NNotd4pO0Zw1oLrYk5WNuuVrmTU01HJgsTRfKlo=";
    })
  ];

  postPatch = ''
    # building the docs fails with the usual Qt xcb error, so skip:
    substituteInPlace setup.py \
      --replace "build.build.run(self)" "build.build.run(self); return"
  '';

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
    # Should be fixed in a version from after March 26, see:
    # https://github.com/enthought/mayavi/issues/1284#issuecomment-2020631244
    broken = pythonAtLeast "3.12";
  };
}
