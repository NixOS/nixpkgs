{ lib, buildPythonPackage, fetchPypi, numpy, pandas }:

buildPythonPackage rec {
  pname = "histbook";
  version = "1.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "864b2943005d6be0c889504c6e1090fea2036c9557837e06ca83d06590037c49";
  };

  propagatedBuildInputs = [ numpy pandas ];

  meta = with lib; {
    homepage = https://github.com/scikit-hep/histbook;
    description = "Versatile, high-performance histogram toolkit for Numpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
