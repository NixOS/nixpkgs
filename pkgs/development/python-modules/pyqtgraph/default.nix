{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pyopengl
, pyqt5
, scipy
}:

buildPythonPackage rec {
  pname = "pyqtgraph";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2ef3b5289184fb48dfe5f44ccb58d9d64ffb5452fc524a2bd7a640a36b3874d";
  };

  propagatedBuildInputs = [ numpy pyopengl pyqt5 scipy ];

  doCheck = false;  # tries to create windows (QApps) on collection, which fails (probably due to no display)

  pythonImportsCheck = [ "pyqtgraph" ];

  meta = with lib; {
    description = "Scientific Graphics and GUI Library for Python";
    homepage = "http://www.pyqtgraph.org/";
    changelog = "https://github.com/pyqtgraph/pyqtgraph/blob/master/CHANGELOG";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ koral ];
  };

}
