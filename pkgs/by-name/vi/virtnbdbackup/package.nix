{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "virtnbdbackup";
  version = "2.47";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abbbi";
    repo = "virtnbdbackup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YcSYuXL7jZn2g4Uluw35ID/1EqJCs8M2M+2dYywupjk=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    libvirt-python
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
    changelog = "https://github.com/abbbi/virtnbdbackup/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "virtnbdbackup";
  };
})
