{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  libusb-package,
  pyusb,
  pyserial,
  udevCheckHook,
  setuptools,
  wheel,
  setuptools-scm,
  scipy,
  numpy,
  packaging,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "cflib";
  version = "0.1.28";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bitcraze";
    repo = "crazyflie-lib-python";
    tag = version;
    hash = "sha256-vGqwQVD80NcFJosVAmqj66uxYNoVtAqzVhVQiuWP5yM=";
  };

  strictDeps = true;

  nativeBuildInputs = [ udevCheckHook ];

  build-system = [
    setuptools
    wheel
    setuptools-scm
  ];

  pythonRelaxDeps = [ "numpy" ];

  dependencies = [
    pyusb
    scipy
    numpy
    packaging
    libusb-package
  ];

  propagatedBuildInputs = [
    pyusb
    pyserial
  ];

  disabledTestPaths = [
    "sys_test/single_cf_grounded/" # exception: Cannot find a Crazyradio Dongle (HW required)
    "sys_test/swarm_test_rig/" # exception: Cannot find a Crazyradio Dongle (HW required)
  ];

  pythonImportsCheck = [ "cflib" ];
  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  doInstallCheck = true;

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
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.brianmcgillion ];
    platforms = lib.platforms.linux;
  };
}
