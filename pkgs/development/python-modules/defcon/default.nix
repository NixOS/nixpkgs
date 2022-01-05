{ lib, buildPythonPackage, fetchPypi, pythonOlder
, fonttools, setuptools-scm
, pytest, pytest-runner, lxml, fs, unicodedata2, fontpens
}:

buildPythonPackage rec {
  pname = "defcon";
  version = "0.10.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a009862a0bc3f41f2b1a1b1f80d6aeedb3a17ed77d598da09f5a1bd93e970b3c";
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
