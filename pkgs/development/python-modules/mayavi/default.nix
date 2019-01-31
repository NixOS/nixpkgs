{ stdenv, fetchPypi, buildPythonPackage
, wxPython, pygments, numpy, vtk, traitsui, envisage, apptools
, nose, mock
, isPy3k
}:

buildPythonPackage rec {
  pname = "mayavi";
  version = "4.7.0";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.bz2";
    sha256 = "02rg4j1vkny2piqn3f728kg34m54kgx396g6h5y7ykz2lk3f3h44";
  };

  # Discovery of 'vtk' in setuptools is not working properly, due to a missing
  # .egg-info in the vtk package. It does however import and run just fine.
  postPatch = ''
    substituteInPlace mayavi/__init__.py --replace "'vtk'" ""
  '';

  propagatedBuildInputs = [ wxPython pygments numpy vtk traitsui envisage apptools ];

  checkInputs = [ nose mock ];

  disabled = isPy3k; # TODO: This would need pyqt5 instead of wxPython

  doCheck = false; # Needs X server

  meta = with stdenv.lib; {
    description = "3D visualization of scientific data in Python";
    homepage = https://github.com/enthought/mayavi;
    maintainers = with stdenv.lib.maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
