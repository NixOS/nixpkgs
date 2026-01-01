{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "virtnbdbackup";
<<<<<<< HEAD
  version = "2.42";
=======
  version = "2.39";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abbbi";
    repo = "virtnbdbackup";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qMeb4mdseR3Zukhnit8HMpRfWbu0HO53FuZh7/c5cTc=";
=======
    hash = "sha256-YYmvWMWWMCNRWICHVSzRyae77YCSkrvh4mRJC0xpAbE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
