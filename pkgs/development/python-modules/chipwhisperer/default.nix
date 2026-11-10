{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  setuptools,
  setuptools-scm,
  cython,

  # dependencies
  colorama,
  configobj,
  ecpy,
  fastdtw,
  libusb1,
  pyserial,
  tqdm,
  numba,
  zarr,
  crc,
  pycryptodome,

  # install
  udevCheckHook,

  # check
  writableTmpDirAsHomeHook,
  pytestCheckHook,
}:

# Usage:
# In NixOS, add the package to services.udev.packages for non-root plugdev
# users to get device access permission:
#    services.udev.packages = [ pkgs.python3Packages.chipwhisperer ];

buildPythonPackage rec {
  pname = "chipwhisperer";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "newaetech";
    repo = "chipwhisperer";
    tag = "v${version}";
    hash = "sha256-/YqNpNccJo+AmRfU5LwkVxK9wIIAUrtwjOfzH83NadU=";
  };

  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    cython
  ];

  dependencies = [
    colorama
    configobj
    ecpy
    fastdtw
    libusb1
    pyserial
    tqdm
    numba
    zarr
    crc
    pycryptodome
  ];

  nativeInstallCheckInputs = [
    udevCheckHook
  ];
  postPatch = ''
    substituteInPlace software/chipwhisperer/__init__.py \
      --replace-fail "__version__ = '6.0.0'" "__version__ = '6.1.0'"
  ''; # the repo erroneously labels the version as 6.0.0 instead of the 6.1.0 which it really is

  postInstall = ''
    # Install udev rules
    # The 50-newae.rules file from the repo isn't directly installed, since it
    # installs to the chipwhisperer group (and not to uaccess)

    mkdir -p $out/etc/udev/rules.d

    cat <<EOF > $out/etc/udev/rules.d/50-newae.rules
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="*", TAG+="uaccess"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="*", TAG+="uaccess", SYMLINK+="cw_serial%n"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="6124", TAG+="uaccess", SYMLINK+="cw_bootloader%n"
    EOF
  '';

  pythonImportsCheck = [ "chipwhisperer" ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
  ];

  enabledTestPaths = [
    # All other tests require connected hardware
    # Error: "Could not find ChipWhisperer. Is it connected?"
    # See: https://chipwhisperer.readthedocs.io/en/latest/contributing.html#unit-tests
    "tests/test_api.py"
  ];

  disabledTests = [ "TestCPA" ]; # Tries to open a tutorial project

  meta = {
    description = "Toolchain for side-channel power analysis and glitching attacks";
    homepage = "https://github.com/newaetech/chipwhisperer";
    changelog = "https://github.com/newaetech/chipwhisperer/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.krishnans2006 ];
  };
}
