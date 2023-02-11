{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:
buildPythonPackage rec {
  pname = "bech32";
  version = "1.2.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fW24IUYDvXhx/PpsCCbvaLhbCr2Q+iHChanF4h0r2Jk=";
  };

  meta = with lib; {
    homepage = "https://pypi.org/project/bech32/";
    license = with licenses; [ mit ];
  };
}
