{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "anyascii";
  version = "0.3.0";
  format = "setuptools";
  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JPJ0Mftkxsk6MxJftm+MugB6UmK8H6q+r+2l9LtwtZM=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Unicode to ASCII transliteration";
    homepage = "https://github.com/anyascii/anyascii";
    license = licenses.isc;
    maintainers = teams.tts.members;
  };
}
