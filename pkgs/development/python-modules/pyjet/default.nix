{ lib, buildPythonPackage, fetchPypi, cython, nose, numpy }:

buildPythonPackage rec {
  pname = "pyjet";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab6e63f8a8fd73bbd76ef2a384eea69bc1c201f2ce876faa4151ade6c0b20615";
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
