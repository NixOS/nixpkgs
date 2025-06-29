{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  python,
  callPackage,

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
  version = "0.2.3";
  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "cynthion";
    tag = version;
    hash = "sha256-NAsELeOnWgMa6iWCJ0+hpbHIO3BsZBv0N/nK1XP+IpU=";
  };
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
  moondancer = (callPackage ./moondancer.nix { inherit src version; });
in
buildPythonPackage {
  pname = "cynthion";

  inherit version src;

  pyproject = true;

  sourceRoot = "${src.name}/cynthion/python";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    setuptools
  ];

  pythonRemoveDeps = [ "future" ];

  dependencies = [
    amaranth
    apollo-fpga
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

  postInstall = ''
    install -Dm444 ${moondancer}/bin/moondancer $out/${python.sitePackages}/cynthion/assets/moondancer.bin
  '';

  meta = {
    description = "Python package and utilities for the Great Scott Gadgets Cynthion USB Test Instrument";
    homepage = "https://github.com/greatscottgadgets/cynthion";
    changelog = "https://github.com/greatscottgadgets/cynthion/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ carlossless ];
  };
}
