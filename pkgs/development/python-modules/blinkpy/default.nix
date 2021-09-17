{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, python-dateutil
, python-slugify
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "blinkpy";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "fronzbot";
    repo = "blinkpy";
    rev = "v${version}";
    sha256 = "11h4r2vkrlxwjig1lay1n5wpny5isfgz85f7lsn8ndnqa2wpsymp";
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
