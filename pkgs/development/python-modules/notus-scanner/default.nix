{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  poetry-core,
  psutil,
  pytestCheckHook,
  python-gnupg,
  pythonOlder,
  sentry-sdk,
  tomli,
}:

buildPythonPackage rec {
  pname = "notus-scanner";
  version = "22.6.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "notus-scanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-PPwQjZIKSQ1OmyYJ8ErkqdbHZfH4iHPMiDdKZ3imBwo=";
  };

  pythonRelaxDeps = [
    "packaging"
    "psutil"
    "python-gnupg"
  ];

  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    paho-mqtt
    psutil
    python-gnupg
    sentry-sdk
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "notus.scanner" ];

  meta = with lib; {
    description = "Helper to create results from local security checks";
    homepage = "https://github.com/greenbone/notus-scanner";
    changelog = "https://github.com/greenbone/notus-scanner/releases/tag/v${version}";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
