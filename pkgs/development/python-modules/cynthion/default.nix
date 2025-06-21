{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  python,

  # gateware
  makeSetupHook,
  nextpnr,
  trellis,
  which,
  yosys,

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
let
  build-gateware-hook = makeSetupHook {
    name = "build-gateware-hook";
    substitutions = {
      pythonSitePackages = python.sitePackages;
    };
    propagatedBuildInputs = [
      nextpnr
      trellis
      which
      yosys
    ];
  } ./build-gateware.sh;
in
buildPythonPackage rec {
  pname = "cynthion";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "cynthion";
    tag = version;
    hash = "sha256-rbvw2eieZwTxStwCRuvIx/f4vdPsOFnV/U80Ga+fNPA=";
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

  nativeBuildInputs = [
    build-gateware-hook
  ];
  nativeCheckInputs = [
    pytestCheckHook
  ];

  enableParallelBuilding = true;

  pythonImportsCheck = [ "cynthion" ];

  meta = {
    changelog = "https://github.com/greatscottgadgets/cynthion/releases/tag/${src.tag}";
    description = "Python package and utilities for the Great Scott Gadgets Cynthion USB Test Instrument";
    homepage = "https://github.com/greatscottgadgets/cynthion";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ carlossless ];
  };
}
