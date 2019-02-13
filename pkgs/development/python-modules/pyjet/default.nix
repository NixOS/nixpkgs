{ lib, buildPythonPackage, fetchPypi, cython, nose, numpy }:

buildPythonPackage rec {
  pname = "pyjet";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1glcwv9ni8i40smfw6m456xjadlkackim5nk33xmas1fa96lpagg";
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
