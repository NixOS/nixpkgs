{ lib, buildPythonPackage, fetchPypi, numpy, pandas }:

buildPythonPackage rec {
  pname = "histbook";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12d5l4c5pxwac5hzcfif51j87qjljm0w9nd0c8pnhj7q2snap4x4";
  };

  propagatedBuildInputs = [ numpy pandas ];

  meta = with lib; {
    homepage = https://github.com/scikit-hep/histbook;
    description = "Versatile, high-performance histogram toolkit for Numpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
