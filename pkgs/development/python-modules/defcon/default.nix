{ lib, buildPythonPackage, fetchPypi, pythonOlder
, fonttools
, pytest, pytestrunner, lxml, fs, unicodedata2, fontpens
}:

buildPythonPackage rec {
  pname = "defcon";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lfqsvxmq1j0nvp26gidnqkj1dyxv7jalc6i7fz1r3nc7niflrqr";
    extension = "zip";
  };

  propagatedBuildInputs = [
    fonttools
  ];

  checkInputs = [
    pytest
    pytestrunner
    lxml
    fs
    unicodedata2
    fontpens
  ];

  meta = with lib; {
    description = "A set of UFO based objects for use in font editing applications";
    homepage = "https://github.com/robotools/defcon";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
