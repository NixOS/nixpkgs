{
  lib,
  buildPythonPackage,
  distro,
  fetchFromGitHub,
  pyasyncore,
  pysnmp,
  pytestCheckHook,
  python-gnupg,
  pythonAtLeast,
  pythonOlder,
  qrcode,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "blocksat-cli";
  version = "2.4.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Blockstream";
    repo = "satellite";
    rev = "refs/tags/v${version}";
    hash = "sha256-1gz2lAS/AHeY54AaVXGeofLC68KjAP7POsIaBL3v2EY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    distro
    pysnmp
    python-gnupg
    qrcode
    requests
  ] ++ lib.optionals (pythonAtLeast "3.12") [ pyasyncore ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_monitor_get_stats"
    "test_monitor_update_with_reporting_enabled"
    "test_erasure_recovery"
  ];

  pythonImportsCheck = [ "blocksatcli" ];

  meta = with lib; {
    description = "Blockstream Satellite CLI";
    mainProgram = "blocksat-cli";
    homepage = "https://github.com/Blockstream/satellite";
    changelog = "https://github.com/Blockstream/satellite/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ prusnak ];
  };
}
