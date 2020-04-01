{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestrunner
, numpy
, pillow
}:

buildPythonPackage rec {
  version = "1.4.1";
  pname = "pydicom";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ki4736h6mp77733rsrwicl8pyig39idywzcmwvw3nzi2r1yc7w8";
  };

  propagatedBuildInputs = [ numpy pillow ];
  checkInputs = [ pytest pytestrunner ];

  meta = with stdenv.lib; {
    homepage = https://pydicom.github.io;
    description = "Pure-Python package for working with DICOM files";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
