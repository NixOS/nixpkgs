{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, voluptuous
}:

buildPythonPackage rec {
  pname = "hatasmota";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "emontnemery";
    repo = pname;
    rev = version;
    sha256 = "sha256-+4jlzemF5f4Qz4QHDaErsmVHq1Pjn/vsvoq/oCbW/hI=";
  };

  propagatedBuildInputs = [
    attrs
    voluptuous
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "hatasmota" ];

  meta = with lib; {
    description = "Python module to help parse and construct Tasmota MQTT messages";
    homepage = "https://github.com/emontnemery/hatasmota";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
