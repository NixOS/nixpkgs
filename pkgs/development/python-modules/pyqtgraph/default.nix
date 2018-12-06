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
  version = "0.9.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "188pcxf3sxxjf0aipjn820lx2rf9f42zzp0sibmcl90955a3ipf1";
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
