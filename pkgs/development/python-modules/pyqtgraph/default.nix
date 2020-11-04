{ stdenv
, buildPythonPackage
, fetchPypi
, scipy
, numpy
, pyqt4
, pyopengl
}:

buildPythonPackage rec {
  pname = "pyqtgraph";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p5k73wjfh0zzjvby8b5107cx7x0c2rdj66zh1nc8y95i0anf2na";
  };

  propagatedBuildInputs = [ scipy numpy pyqt4 pyopengl ];

  doCheck = false;  # "PyQtGraph requires either PyQt4 or PySide; neither package could be imported."

  meta = with stdenv.lib; {
    description = "Scientific Graphics and GUI Library for Python";
    homepage = "http://www.pyqtgraph.org/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ koral ];
  };

}
