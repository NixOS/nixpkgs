{ lib, buildPythonPackage, fetchPypi, pythonOlder
, fonttools, setuptools-scm
, pytest, pytest-runner, lxml, fs, unicodedata2, fontpens
}:

buildPythonPackage rec {
  pname = "defcon";
  version = "0.8.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sj9yhwkyvzchglpy07pkx5362mwlap581ibv150b5l9s5mxn2j1";
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
