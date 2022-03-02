{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, freezegun
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "itsdangerous";
  version = "2.1.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2Ej8uLx9UHxFRrRIV06KRPxOorqE6/jXgykNU+gZkvU=";
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
