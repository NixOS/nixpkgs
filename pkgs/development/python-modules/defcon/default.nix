{ lib, buildPythonPackage, fetchPypi, pythonOlder
, fonttools, setuptools-scm
, pytest, pytest-runner, lxml, fs, unicodedata2, fontpens
}:

buildPythonPackage rec {
  pname = "defcon";
  version = "0.9.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "140f51da51e9630a9fa11dfd34376c4e29785fdb0bddc2e371df5b36bec17b76";
    extension = "zip";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    fonttools
  ];

  checkInputs = [
    pytest
    pytest-runner
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
