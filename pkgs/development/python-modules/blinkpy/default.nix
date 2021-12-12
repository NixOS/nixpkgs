{ lib
, buildPythonPackage
, fetchFromGitHub
, python-dateutil
, python-slugify
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "blinkpy";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "fronzbot";
    repo = "blinkpy";
    rev = "v${version}";
    sha256 = "1vmi8r48kcg79nf890r2fqfk9syih8rs1d5va7dr64shflcyi8gp";
  };

  propagatedBuildInputs = [
    python-dateutil
    python-slugify
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "blinkpy"
    "blinkpy.api"
    "blinkpy.auth"
    "blinkpy.blinkpy"
    "blinkpy.camera"
    "blinkpy.helpers.util"
    "blinkpy.sync_module"
  ];

  meta = with lib; {
    description = "Python library for the Blink Camera system";
    homepage = "https://github.com/fronzbot/blinkpy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
