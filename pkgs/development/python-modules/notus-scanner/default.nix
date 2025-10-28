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
  version = "22.7.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "notus-scanner";
    tag = "v${version}";
    hash = "sha256-JKDnqgEBzEIOI3WIh+SOycACFaYZoZHy7tPFirltDiM=";
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
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "notus.scanner" ];

  meta = with lib; {
    description = "Helper to create results from local security checks";
    homepage = "https://github.com/greenbone/notus-scanner";
    changelog = "https://github.com/greenbone/notus-scanner/releases/tag/${src.tag}";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
