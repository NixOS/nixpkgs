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
  version = "2.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Blockstream";
    repo = "satellite";
    tag = "v${version}";
    hash = "sha256-SH1MZx/ZkhhWhxhREqFCGoob58J2XMZSpe+q7UgiyF4=";
  };

  # Upstream setup.py installs both the CLI and GUI versions.
  # To pull only the required dependencyes, either setup_cli.py or setup_gui.py should be used.
  postPatch = ''
    mv setup_cli.py setup.py
  '';

  pythonRelaxDeps = [ "pyasyncore" ];

  build-system = [ setuptools ];

  dependencies = [
    distro
    pysnmp
    pysnmplib
    python-gnupg
    qrcode
    requests
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [ pyasyncore ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_monitor_get_stats"
    "test_monitor_update_with_reporting_enabled"
    "test_erasure_recovery"
    # Non-NixOS package managers are not present in the build environment.
    "test_parse_upgradable_list_apt"
    "test_parse_upgradable_list_dnf"
    # Fails due to GPG clearsign output lacking trailing newline in some setups.
    "test_clearsign_verification"
  ];

  disabledTestPaths = [ "blocksatgui/tests/" ];

  pythonImportsCheck = [ "blocksatcli" ];

  meta = with lib; {
    description = "Blockstream Satellite CLI";
    homepage = "https://github.com/Blockstream/satellite";
    changelog = "https://github.com/Blockstream/satellite/releases/tag/${src.tag}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ prusnak ];
    mainProgram = "blocksat-cli";
  };
}
