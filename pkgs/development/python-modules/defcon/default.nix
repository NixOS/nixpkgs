{ lib
, buildPythonPackage
, fetchPypi
, fontpens
, fonttools
, fs
, lxml
, pytestCheckHook
, pythonOlder
, setuptools-scm
, unicodedata2
}:

buildPythonPackage rec {
  pname = "defcon";
  version = "0.10.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ruOW5taeRa5lyCZHgTktTCkRaTSyc3rXbYIwtAwYKkQ=";
    extension = "zip";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    fonttools
  ];

  checkInputs = [
    fontpens
    fs
    lxml
    pytestCheckHook
    unicodedata2
  ];

  pythonImportsCheck = [
    "defcon"
  ];

  meta = with lib; {
    description = "A set of UFO based objects for use in font editing applications";
    homepage = "https://github.com/robotools/defcon";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
