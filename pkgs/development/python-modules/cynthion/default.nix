{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  amaranth,
  apollo-fpga,
  future,
  libusb1,
  luna-soc,
  luna-usb,
  prompt-toolkit,
  pyfwup,
  pygreat,
  pyserial,
  pyusb,
  tabulate,
  tomli,
  tqdm,

  # tests
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "cynthion";
  version = "0.1.8";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "cynthion";
    tag = version;
    hash = "sha256-twkCv47Goob2cO7FeHegvab3asf8fqbY9qg97Vw4ZCo=";
  };

  sourceRoot = "${src.name}/cynthion/python";

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
    apollo-fpga
    future
    libusb1
    luna-soc
    luna-usb
    prompt-toolkit
    pyfwup
    pygreat
    pyserial
    pyusb
    tabulate
    tomli
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cynthion" ];

  meta = {
    changelog = "https://github.com/greatscottgadgets/cynthion/releases/tag/${version}";
    description = "Python package and utilities for the Great Scott Gadgets Cynthion USB Test Instrument";
    homepage = "https://github.com/greatscottgadgets/cynthion";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ carlossless ];
    broken = lib.versionAtLeast amaranth.version "0.5";
  };
}
