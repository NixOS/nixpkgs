{ lib, attrs, buildPythonPackage, fetchFromGitHub, voluptuous, pythonOlder }:

buildPythonPackage rec {
  pname = "hatasmota";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emontnemery";
    repo = pname;
    rev = version;
    sha256 = "sha256-KPFnlw6rk+jDKs8Ss/34lIt0MsAQGernCyyF1ImRylA=";
  };

  propagatedBuildInputs = [ attrs voluptuous ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "hatasmota" ];

  meta = with lib; {
    description =
      "Python module to help parse and construct Tasmota MQTT messages";
    homepage = "https://github.com/emontnemery/hatasmota";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
