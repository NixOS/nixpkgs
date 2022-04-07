{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "anyascii";
  version = "0.3.1";
  format = "setuptools";
  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3t9XcoIG4obJHu18dZUFpeRcjNATZ91Awvcki7FcEfY=";
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
