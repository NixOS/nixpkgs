{
  aiohttp,
  appdirs,
  buildPythonPackage,
  click,
  cryptography,
  fetchFromGitHub,
  grpcio,
  humanize,
  lib,
  libusb-package,
  libusb1,
  platformdirs,
  prettytable,
  prompt-toolkit,
  protobuf,
  pyee,
  pyserial,
  pyserial-asyncio,
  pytest-asyncio,
  pytestCheckHook,
  pyusb,
  setuptools,
  setuptools-scm,
  tomli,
  websockets,
}:

buildPythonPackage rec {
  pname = "bumble";
  version = "0.0.221";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "bumble";
    tag = "v${version}";
    hash = "sha256-GCcvbYLHChvrsQuhFjeYnncjrzFqOlmL+LlG7t2iAkE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "libusb-package"
  ];

  dependencies = [
    aiohttp
    appdirs
    click
    cryptography
    grpcio
    humanize
    libusb-package
    libusb1
    platformdirs
    prettytable
    prompt-toolkit
    protobuf
    pyee
    pyserial
    pyserial-asyncio
    pyusb
    tomli
    websockets
  ];

  pythonImportsCheck = [ "bumble" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlags = [ "--asyncio-mode=auto" ];

  disabledTests = [
    # tests require networking
    "test_android_netsim_connection"
    "test_open_transport_with_metadata"
  ];

  meta = {
    changelog = "https://github.com/google/bumble/releases/tag/${src.tag}";
    description = "Bluetooth Stack for Apps, Emulation, Test and Experimentation";
    homepage = "https://github.com/google/bumble";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
