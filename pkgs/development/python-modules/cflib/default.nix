{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  libusb-package,
  numpy,
  packaging,
  pyserial,
  pyusb,
  scipy,
  pytestCheckHook,
  pyyaml,
  udevCheckHook,
}:

buildPythonPackage rec {
  pname = "cflib";
  version = "0.1.28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bitcraze";
    repo = "crazyflie-lib-python";
    tag = version;
    hash = "sha256-vGqwQVD80NcFJosVAmqj66uxYNoVtAqzVhVQiuWP5yM=";
  };

  strictDeps = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "numpy"
    "packaging"
  ];

  dependencies = [
    libusb-package
    numpy
    packaging
    pyserial
    pyusb
    scipy
  ];

  disabledTestPaths = [
    # exception: Cannot find a Crazyradio Dongle (HW required)
    "sys_test/single_cf_grounded/"
    "sys_test/swarm_test_rig/"
  ];

  pythonImportsCheck = [ "cflib" ];
  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  # The udevCheckHook is used to verify udev rules
  # requires diInstallCheck to be enabled, which is default for pythonPackages
  nativeInstallCheckInputs = [
    udevCheckHook
  ];

  # Install udev rules as defined
  # https://www.bitcraze.io/documentation/repository/crazyflie-lib-python/master/installation/usb_permissions/
  postInstall = ''
    # Install udev rules
    mkdir -p $out/etc/udev/rules.d

    cat <<EOF > $out/etc/udev/rules.d/99-bitcraze.rules
    # Crazyradio (normal operation)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="7777", MODE="0664", GROUP="plugdev"
    # Bootloader
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="0101", MODE="0664", GROUP="plugdev"
    # Crazyflie (over USB)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0664", GROUP="plugdev"
    EOF
  '';

  meta = {
    description = "Python library for the Crazyflie quadcopter by Bitcraze";
    homepage = "https://github.com/bitcraze/crazyflie-lib-python";
    changelog = "https://github.com/bitcraze/crazyflie-lib-python/releases/tag/${version}";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.brianmcgillion ];
    platforms = lib.platforms.linux;
  };
}
