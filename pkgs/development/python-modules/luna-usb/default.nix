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
buildPythonPackage (finalAttrs: {
  pname = "luna-usb";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "luna";
    tag = finalAttrs.version;
    hash = "sha256-kH5PlgJRMymBZZ3oANR8xlAUPUgGZjqw9s9DcpQ809A=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${finalAttrs.version}"'
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

  enabledTestPaths = [
    "tests/"
  ];

  pythonImportsCheck = [
    "luna"
  ];

  meta = {
    changelog = "https://github.com/greatscottgadgets/luna/releases/tag/${finalAttrs.src.tag}";
    description = "Amaranth HDL framework for monitoring, hacking, and developing USB devices";
    homepage = "https://github.com/greatscottgadgets/luna";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ karstx ];
  };
})
