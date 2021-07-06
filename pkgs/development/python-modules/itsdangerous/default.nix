{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, freezegun
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "itsdangerous";
  version = "2.0.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w6gfb2zhbcmrfj6digwzw1z68w6zg1q87rm6la2m412zil4swly";
  };

  checkInputs = [
    freezegun
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Safely pass data to untrusted environments and back";
    homepage = "https://itsdangerous.palletsprojects.com";
    license = licenses.bsd3;
  };

}
