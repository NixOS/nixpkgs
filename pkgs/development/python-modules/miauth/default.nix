{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, bluepy
, pythonOlder
, cryptography
}:

buildPythonPackage rec {
  pname = "miauth";
  version = "0.9.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dnandha";
    repo = "miauth";
    # Release is not tagged properly, https://github.com/dnandha/miauth/issues/15
    # rev = "refs/tags/${version}";
    rev = "refs/tags/release";
    hash = "sha256-+aoY0Eyd9y7xQTA3uSC6YIZisViilsHlFaOXmhPMcBY=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    bluepy
    cryptography
  ];

  pythonImportsCheck = [
    "miauth"
  ];

  meta = with lib; {
    description = "Authenticate and interact with Xiaomi devices over BLE";
    homepage = "https://github.com/dnandha/miauth";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
