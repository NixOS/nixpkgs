{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "pyfibaro";
  version = "0.7.5";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "rappenze";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-hllYxPPbLu3dpjHwXfIvTMW0LWtcglTVfN7youZaXTw=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "pyfibaro"
  ];

  meta = with lib; {
    description = "Library to access FIBARO Home center";
    homepage = "https://github.com/rappenze/pyfibaro";
    changelog = "https://github.com/rappenze/pyfibaro/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
