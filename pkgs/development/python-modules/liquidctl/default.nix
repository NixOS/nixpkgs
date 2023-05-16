{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, installShellFiles
, setuptools
<<<<<<< HEAD
, setuptools-scm
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, docopt
, hidapi
, pyusb
, smbus-cffi
, i2c-tools
, pytestCheckHook
, colorlog
, crcmod
, pillow
}:

buildPythonPackage rec {
  pname = "liquidctl";
<<<<<<< HEAD
  version = "1.13.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "1.12.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-LU8rQmXrEIoOBTTFotGvMeHqksYGrtNo2YSl2l2e/UI=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    installShellFiles
    setuptools
    setuptools-scm
    wheel
=======
    hash = "sha256-0QjgnTxqB50JNjSUAgBrGyhN2XC/TDYiC1tvhw1Bl1M=";
  };

  nativeBuildInputs = [
    installShellFiles
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  propagatedNativeBuildInputs = [
    smbus-cffi
  ];

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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postBuild = ''
    # needed for pythonImportsCheck
    export XDG_RUNTIME_DIR=$TMPDIR
  '';

  pythonImportsCheck = [
    "liquidctl"
  ];

  meta = with lib; {
    description = "Cross-platform CLI and Python drivers for AIO liquid coolers and other devices";
    homepage = "https://github.com/liquidctl/liquidctl";
    changelog = "https://github.com/liquidctl/liquidctl/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ arturcygan evils ];
  };
}
