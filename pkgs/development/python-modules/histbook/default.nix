{ lib, buildPythonPackage, fetchPypi, numpy, pandas }:

buildPythonPackage rec {
  pname = "histbook";
  version = "1.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76d1f143f8abccf5539029fbef8133db84f377fc7752ac9e7e6d19ac9a277967";
  };

  propagatedBuildInputs = [ numpy pandas ];

  meta = with lib; {
    homepage = https://github.com/scikit-hep/histbook;
    description = "Versatile, high-performance histogram toolkit for Numpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
