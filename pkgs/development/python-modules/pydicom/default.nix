{ stdenv
, buildPythonPackage
, isPy27
, fetchPypi
, pytest
, pytestrunner
, numpy
, pillow
}:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "pydicom";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w3l5bf01dbyr3rp5an5dxvhqxzvd2p530s9kx1yy5f42pvr2k2r";
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
