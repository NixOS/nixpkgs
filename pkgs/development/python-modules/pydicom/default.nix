{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestrunner
, numpy
, pillow
}:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "pydicom";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1j11lsykqbnw9d6gzgj6kfn6lawvm5d9azd9palj3l1xhj0hlnsq";
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
