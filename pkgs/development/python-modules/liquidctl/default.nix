{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  installShellFiles,
  setuptools,
  setuptools-scm,
  wheel,
  docopt,
  hidapi,
  pyusb,
  smbus-cffi,
  i2c-tools,
  pytestCheckHook,
  colorlog,
  crcmod,
  pillow,
  udevCheckHook,
}:

buildPythonPackage rec {
  pname = "liquidctl";
  version = "1.15.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "liquidctl";
    repo = "liquidctl";
    tag = "v${version}";
    hash = "sha256-ifYPUAF0lR9aCwiseNQZXbq+d+CXD/MwnZQhAM1TRLI=";
  };

  nativeBuildInputs = [
    installShellFiles
    setuptools
    setuptools-scm
    wheel
    udevCheckHook
  ];

  propagatedBuildInputs = [
    docopt
    hidapi
    pyusb
    smbus-cffi
    i2c-tools
    colorlog
    crcmod
    pillow
  ];

  propagatedNativeBuildInputs = [ smbus-cffi ];

  outputs = [
    "out"
    "man"
  ];

  postInstall = ''
    installManPage liquidctl.8
    installShellCompletion extra/completions/liquidctl.bash

    mkdir -p $out/lib/udev/rules.d
    cp extra/linux/71-liquidctl.rules $out/lib/udev/rules.d/.
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  postBuild = ''
    # needed for pythonImportsCheck
    export XDG_RUNTIME_DIR=$TMPDIR
  '';

  pythonImportsCheck = [ "liquidctl" ];

  meta = with lib; {
    description = "Cross-platform CLI and Python drivers for AIO liquid coolers and other devices";
    homepage = "https://github.com/liquidctl/liquidctl";
    changelog = "https://github.com/liquidctl/liquidctl/blob/${src.tag}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      arturcygan
      evils
    ];
    mainProgram = "liquidctl";
  };
}
