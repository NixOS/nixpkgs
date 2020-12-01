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
  version = "2.1.1";
  pname = "pydicom";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "72a11086f6a277c1529a552583fde73e03256a912173f15e9bc256e5b28f28f1";
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
