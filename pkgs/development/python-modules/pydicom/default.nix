{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
, pytestrunner
, pytestCheckHook
, numpy
, pillow
}:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "pydicom";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "594c91f715c415ef439f498351ae68fb770c776fc5aa72f3c87eb500dc2a7470";
  };

  propagatedBuildInputs = [ numpy pillow ];

  checkInputs = [ pytest pytestrunner pytestCheckHook ];
  disabledTests = [ "test_invalid_bit_depth_raises" ];
  # harmless failure; see https://github.com/pydicom/pydicom/issues/1119

  meta = with stdenv.lib; {
    homepage = "https://pydicom.github.io";
    description = "Pure-Python package for working with DICOM files";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
