{ lib, buildPythonPackage, fetchPypi, cython, nose, numpy }:

buildPythonPackage rec {
  pname = "pyjet";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "89ce11cd4541fb573d68fd60a219e5e1bdeb94cfcfffc917b472fde2aa9a5a31";
  };

  # fix for python37
  # https://github.com/scikit-hep/pyjet/issues/8
  nativeBuildInputs = [ cython ];
  preBuild = ''
    for f in pyjet/src/*.{pyx,pxd}; do
      cython --cplus "$f"
    done
  '';

  propagatedBuildInputs = [ numpy ];
  checkInputs = [ nose ];

  meta = with lib; {
    homepage = "https://github.com/scikit-hep/pyjet";
    description = "The interface between FastJet and NumPy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ veprbl ];
  };
}
