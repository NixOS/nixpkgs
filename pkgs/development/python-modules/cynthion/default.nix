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
  udevCheckHook,
}:
let
  version = "0.2.4";
  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "cynthion";
    tag = version;
    hash = "sha256-ebd2L7o6GO57TpwJ7+MOhVSb+I/E8kD7d7DqPj4B3FM=";
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

  nativeBuildInputs = [
    build-gateware-hook
  ];

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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  nativeInstallCheckInputs = [ udevCheckHook ];

  enableParallelBuilding = true;

  pythonImportsCheck = [ "cynthion" ];

  postInstall = ''
    # Install moondancer firmware
    install -Dm444 ${moondancer}/bin/moondancer $out/${python.sitePackages}/cynthion/assets/moondancer.bin

    # Make udev rules available for NixOS option services.udev.packages
    install -Dm444 \
      -t $out/lib/udev/rules.d \
      build/lib/cynthion/assets/54-cynthion.rules
  '';

  meta = {
    description = "Python package and utilities for the Great Scott Gadgets Cynthion USB Test Instrument";
    homepage = "https://github.com/greatscottgadgets/cynthion";
    changelog = "https://github.com/greatscottgadgets/cynthion/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ carlossless ];
  };
}
