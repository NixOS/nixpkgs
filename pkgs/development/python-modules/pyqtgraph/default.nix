{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, pyopengl
, pyqt5
, scipy
}:

buildPythonPackage rec {
  pname = "pyqtgraph";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p5k73wjfh0zzjvby8b5107cx7x0c2rdj66zh1nc8y95i0anf2na";
  };

  propagatedBuildInputs = [ numpy pyopengl pyqt5 scipy ];

  doCheck = false;  # tries to create windows (QApps) on collection, which fails (probably due to no display)

  pythonImportsCheck = [ "pyqtgraph" ];

  meta = with stdenv.lib; {
    description = "Scientific Graphics and GUI Library for Python";
    homepage = "http://www.pyqtgraph.org/";
    changelog = "https://github.com/pyqtgraph/pyqtgraph/blob/master/CHANGELOG";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ koral ];
  };

}
