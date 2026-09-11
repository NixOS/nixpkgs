{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "virtnbdbackup";
  version = "2.49";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abbbi";
    repo = "virtnbdbackup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z6lHU28pqO3Xf9470mVInJdv0hh/sgNPnMIt57WFbFk=";
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
