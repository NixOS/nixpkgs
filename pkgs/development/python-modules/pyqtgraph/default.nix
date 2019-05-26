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
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c08ab34881fae5ecf9ddfe6c1220b9e41e6d3eb1579a7d8ef501abb8e509251";
  };

  propagatedBuildInputs = [ scipy numpy pyqt4 pyopengl ];

  doCheck = false;  # "PyQtGraph requires either PyQt4 or PySide; neither package could be imported."

  meta = with stdenv.lib; {
    description = "Scientific Graphics and GUI Library for Python";
    homepage = http://www.pyqtgraph.org/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ koral ];
  };

}
