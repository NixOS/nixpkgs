{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestrunner
, numpy
, pillow
}:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "pydicom";

  src = fetchPypi {
    inherit pname version;
    sha256 = "594c91f715c415ef439f498351ae68fb770c776fc5aa72f3c87eb500dc2a7470";
  };

  propagatedBuildInputs = [ numpy pillow ];
  checkInputs = [ pytest pytestrunner ];

  meta = with stdenv.lib; {
    homepage = "https://pydicom.github.io";
    description = "Pure-Python package for working with DICOM files";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
