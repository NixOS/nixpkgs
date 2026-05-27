{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  poetry-core,
  psutil,
  pytestCheckHook,
  python-gnupg,
  sentry-sdk,
}:

buildPythonPackage rec {
  pname = "notus-scanner";
  version = "22.7.2";
  pyproject = true;

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
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "notus.scanner" ];

  meta = {
    description = "Helper to create results from local security checks";
    homepage = "https://github.com/greenbone/notus-scanner";
    changelog = "https://github.com/greenbone/notus-scanner/releases/tag/${src.tag}";
    license = with lib.licenses; [ agpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
