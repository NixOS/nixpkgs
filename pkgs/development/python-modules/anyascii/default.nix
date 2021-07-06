{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "anyascii";
  version = "0.2.0";
  format = "setuptools";
  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b6jdd9nx15py0jqjdn154m6m491517sqlk57bbyj3x4xzywadkh";
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
