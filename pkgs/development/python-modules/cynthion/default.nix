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
  version = "0.1.7";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "cynthion";
    rev = "refs/tags/${version}";
    hash = "sha256-2nVfODAg4t5hoSKUEP4IN23R+JGe3lw/rpfjW/UIsYw=";
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
