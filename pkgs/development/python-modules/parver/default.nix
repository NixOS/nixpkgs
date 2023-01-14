{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, attrs
, pytestCheckHook
, hypothesis
, pretend
, arpeggio
, typing-extensions
}:

buildPythonPackage rec {
  pname = "parver";
  version = "0.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1KPbuTxTNz7poLoFXkhYxEFpsgS5EuSdAD6tlduam8o=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    attrs
    arpeggio
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
    hypothesis
    pretend
  ];

  meta = with lib; {
    description = "Allows parsing and manipulation of PEP 440 version numbers";
    homepage = "https://github.com/RazerM/parver";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
