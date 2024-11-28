{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  amaranth,
  libusb1,
  pyserial,
  pyusb,
  pyvcd,
  usb-protocol,

  # tests
  pytestCheckHook,
  apollo-fpga,
}:
buildPythonPackage rec {
  pname = "luna-usb";
  version = "0.1.2";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "luna";
    rev = "refs/tags/${version}";
    hash = "sha256-T9V0rI6vcEpM3kN/duRni6v2plCU4B379Zx07dBGKjk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    amaranth
    libusb1
    pyserial
    pyusb
    pyvcd
    usb-protocol
  ];

  nativeCheckInputs = [
    pytestCheckHook
    apollo-fpga
  ];

  pytestFlagsArray = [
    "tests/"
  ];

  pythonImportsCheck = [
    "luna"
  ];

  meta = {
    changelog = "https://github.com/greatscottgadgets/luna/releases/tag/${version}";
    description = "Amaranth HDL framework for monitoring, hacking, and developing USB devices";
    homepage = "https://github.com/greatscottgadgets/luna";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ carlossless ];
    broken = lib.versionAtLeast amaranth.version "0.5";
  };
}
