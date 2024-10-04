{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libusb-package,
  pyusb,
  scipy,
  numpy,
  pytestCheckHook,
  pyyaml,
  pythonOlder,
  bitcraze-udev-rules,
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "cflib";
  version = "0.1.23";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bitcraze";
    repo = "crazyflie-lib-python";
    rev = version;
    hash = "sha256-OZQAisA9b3YIf3zEC5RlrW70h4tgCBC19/KEvle+kLY=";
  };

  propagatedBuildInputs =
    [
      pyusb
      scipy
      numpy
      libusb-package
    ]
    ++ lib.optionals stdenv.isLinux [
      bitcraze-udev-rules
    ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = true;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    pyyaml
  ];

  disabledTestPaths = [
    # Disable tests which require a physical device connection
    "sys_test/single_cf_grounded/test_bootloader.py"
    "sys_test/single_cf_grounded/test_link.py"
    "sys_test/single_cf_grounded/test_power_switch.py"
    "sys_test/swarm_test_rig/test_connection.py"
    "sys_test/swarm_test_rig/test_logging.py"
    "sys_test/swarm_test_rig/test_memory_map.py"
    "sys_test/swarm_test_rig/test_response_time.py"
  ];

  pythonImportsCheck = [ "cflib" ];

  meta = with lib; {
    homepage = "https://github.com/bitcraze/crazyflie-lib-python";
    description = "Python library to communicate with Crazyflie";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      vbruegge
      stargate01
    ];
  };
}
