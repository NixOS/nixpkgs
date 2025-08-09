{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "virtnbdbackup";
  version = "2.32";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abbbi";
    repo = "virtnbdbackup";
    tag = "v${version}";
    hash = "sha256-SCt+RvtY17wTGeCcMbmK7q7cLz17upTEgoKZM4pDh7s=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    libvirt
    tqdm
    libnbd
    lz4
    lxml
    paramiko
    typing-extensions
    colorlog
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "-V";

  pythonImportsCheck = [ "libvirtnbdbackup" ];

  meta = {
    description = "Backup utility for Libvirt/qemu/kvm";
    homepage = "https://github.com/abbbi/virtnbdbackup";
    changelog = "https://github.com/abbbi/virtnbdbackup/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "virtnbdbackup";
  };
}
