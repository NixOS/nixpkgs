{ lib, buildPythonPackage, fetchPypi, pythonOlder
, fonttools, setuptools-scm
, pytest, pytest-runner, lxml, fs, unicodedata2, fontpens
}:

buildPythonPackage rec {
  pname = "defcon";
  version = "0.10.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+nlk9xG3mOCS4xHzp54J/V+he7HNMg1aMgFeTFTrMHA=";
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
