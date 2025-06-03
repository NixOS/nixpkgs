{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

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
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "luna";
    tag = version;
    hash = "sha256-SVpAPq77IH2/2WZrc25j7q6qTMW2ToPY5lYQcYUlJfs=";
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
    changelog = "https://github.com/greatscottgadgets/luna/releases/tag/${src.tag}";
    description = "Amaranth HDL framework for monitoring, hacking, and developing USB devices";
    homepage = "https://github.com/greatscottgadgets/luna";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ carlossless ];
  };
}
