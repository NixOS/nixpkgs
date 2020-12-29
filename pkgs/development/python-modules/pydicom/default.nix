{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, isPy27
, pytest
, pytestCheckHook
, numpy
, pillow
}:
let pydicom-data = buildPythonPackage rec {
  version = "2020.07.27";
  pname = "pydicom-data";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = pname;
    rev = "bbb723879690bb77e077a6d57657930998e92bd5";
    sha256 = "0fdb3rqjd1s2hjylf1vrlzhhkxnb9837s5cnb2idb95gx6ska8kl";
  };

  buildInputs = [ pytest ];
};
in
buildPythonPackage rec {
  version = "2.1.1";
  pname = "pydicom";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "72a11086f6a277c1529a552583fde73e03256a912173f15e9bc256e5b28f28f1";
  };

  propagatedBuildInputs = [ numpy pillow ];

  checkInputs = [ pytestCheckHook pydicom-data ];
  # This test assumes that the directory for pydicom-data is writable, and
  # writes to $HOME
  disabledTests = [ "test_data_manager" ];

  meta = with lib; {
    homepage = "https://pydicom.github.io";
    description = "Pure-Python package for working with DICOM files";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
