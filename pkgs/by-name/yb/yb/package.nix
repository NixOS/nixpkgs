{
  lib,
  python3Packages,
  fetchFromGitHub,
  opensc,
  openssl,
  yubico-piv-tool,
  yubikey-manager,
}:

python3Packages.buildPythonApplication rec {
  pname = "yb";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "yb";
    rev = "v${version}";
    hash = "sha256-Eq3qFDzi/G4qQ3UUZWyl42zMYAO2C0ipV2yXxt2EAUw=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    click
    cryptography
    prompt-toolkit
    pyscard
    pyyaml
    yubikey-manager
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  buildInputs = [
    opensc
    openssl
    yubico-piv-tool
    yubikey-manager
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [
      opensc
      openssl
      yubico-piv-tool
      yubikey-manager
    ]}"
    "--set"
    "LD_LIBRARY_PATH"
    "${yubico-piv-tool}/lib"
  ];

  pythonImportsCheck = [
    "yb"
  ];

  # Run subset of tests that don't require YubiKey hardware
  doCheck = true;
  pytestFlagsArray = [
    "tests"
  ];

  meta = {
    description = "CLI tool for securely storing and retrieving binary blobs using YubiKey";
    longDescription = ''
      yb is a command-line tool that provides secure blob storage using a YubiKey device.
      It leverages the YubiKey's PIV (Personal Identity Verification) application to store
      encrypted or unencrypted binary data in custom PIV data objects. The tool uses hybrid
      encryption (ECDH + AES-256-CBC) to protect sensitive data with hardware-backed
      cryptographic keys.

      Features:
      - Hardware-backed encryption using YubiKey PIV
      - ~36 KB storage capacity (expandable to ~48 KB)
      - PIN-protected management key mode
      - Multi-device support with interactive selection
      - Shell auto-completion for blob names
      - Glob pattern filtering
    '';
    homepage = "https://github.com/douzebis/yb";
    changelog = "https://github.com/douzebis/yb/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
    mainProgram = "yb";
    platforms = lib.platforms.linux;
  };
}
