{ lib, buildPythonPackage, fetchPypi, cython, nose, numpy }:

buildPythonPackage rec {
  pname = "pyjet";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b334fb9a01854165629d49a2df43c81c880fc231a8a27c156beccf42f223fe47";
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
