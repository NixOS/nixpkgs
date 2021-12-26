{ lib, buildPythonPackage, pythonOlder, fetchPypi, wrapQtAppsHook
, pyface, pygments, numpy, vtk, traitsui, envisage, apptools, pyqt5
}:

buildPythonPackage rec {
  pname = "mayavi";
  version = "4.7.4";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "ec50e7ec6afb0f9224ad1863d104a0d1ded6c8deb13e720652007aaca2303332";
  };

  postPatch = ''
    # Discovery of 'vtk' in setuptools is not working properly, due to a missing
    # .egg-info in the vtk package. It does however import and run just fine.
    substituteInPlace mayavi/__init__.py --replace "'vtk'" ""

    # building the docs fails with the usual Qt xcb error, so skip:
    substituteInPlace setup.py \
      --replace "build.build.run(self)" "build.build.run(self); return"
  '';

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = [
    pyface pygments numpy vtk traitsui envisage apptools pyqt5
  ];

  doCheck = false; # Needs X server
  pythonImportsCheck = [ "mayavi" ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "3D visualization of scientific data in Python";
    homepage = "https://github.com/enthought/mayavi";
    maintainers = with maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
