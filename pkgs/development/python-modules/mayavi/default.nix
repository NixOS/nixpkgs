{ lib, buildPythonPackage, isPy27, fetchPypi, wrapQtAppsHook
, pyface, pygments, numpy, vtk_9, traitsui, envisage, apptools, pyqt5
}:

buildPythonPackage rec {
  pname = "mayavi";
  version = "4.7.2";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "0wxk7icv37n4sb28wj8pshf4i4kpp1sisibzmg60wp29aw3jj1x2";
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
    pyface pygments numpy vtk_9 traitsui envisage apptools pyqt5
  ];

  doCheck = false; # Needs X server

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
