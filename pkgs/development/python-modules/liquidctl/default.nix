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
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "liquidctl";
  version = "1.13.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-LU8rQmXrEIoOBTTFotGvMeHqksYGrtNo2YSl2l2e/UI=";
  };

  patches = [
    (fetchpatch {
      name = "tests-pillow-10.2.0-compat.patch";
      url = "https://github.com/liquidctl/liquidctl/commit/c50afa4e610bd2e268e85c347e2644794c817a78.diff";
      hash = "sha256-1cKk3drl3RybHmnPXdlJoeYK6UDz25jHSS2YS/XLHIY=";
    })
  ];

  nativeBuildInputs = [
    installShellFiles
    setuptools
    setuptools-scm
    wheel
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
    changelog = "https://github.com/liquidctl/liquidctl/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      arturcygan
      evils
    ];
    mainProgram = "liquidctl";
  };
}
