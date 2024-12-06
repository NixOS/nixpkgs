{
  lib,
  buildPythonPackage,
  distro,
  fetchFromGitHub,
  pyasyncore,
  pysnmp,
  pysnmplib,
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
  version = "2.4.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Blockstream";
    repo = "satellite";
    rev = "refs/tags/v${version}";
    hash = "sha256-OmIQUrUH3kWgf+v+9Hl2OgDdGPwb3guNY0+H64CWkeg=";
  };

  pythonRelaxDeps = [ "pyasyncore" ];

  build-system = [ setuptools ];

  dependencies = [
    distro
    pysnmp
    pysnmplib
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
    homepage = "https://github.com/Blockstream/satellite";
    changelog = "https://github.com/Blockstream/satellite/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ prusnak ];
    mainProgram = "blocksat-cli";
  };
}
