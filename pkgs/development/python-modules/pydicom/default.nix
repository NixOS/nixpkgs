{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestrunner
, numpy
, pillow
}:

buildPythonPackage rec {
  version = "1.4.2";
  pname = "pydicom";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1483hv74fhfk4q18r4rda7yixqqdxrd1djzp3492s81ykxd4k24l";
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
