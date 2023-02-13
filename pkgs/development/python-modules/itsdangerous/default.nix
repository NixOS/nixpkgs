{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, freezegun
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "itsdangerous";
  version = "2.1.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XbvGizF+XkLzJ/kCF2NUXcP8O/4i5t65aq8fw4h0FWo=";
  };

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Safely pass data to untrusted environments and back";
    homepage = "https://itsdangerous.palletsprojects.com";
    license = licenses.bsd3;
  };

}
