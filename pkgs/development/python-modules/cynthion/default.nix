{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  callPackage,
  python,

  # gateware (FPGA toolchain)
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
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "cynthion";
    tag = version;
    hash = "sha256-Ju01eqBVZ7CD0pw4nIFML4LcCPXzC78dLpQru3a+5bU=";
  };

  # Moondancer SoC firmware, required for `cynthion flash facedancer`.
  moondancer = callPackage ./moondancer.nix { inherit src version; };
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
    udevCheckHook

    # Used by the gateware build in postInstall.
    nextpnr
    trellis
    which
    yosys
  ];

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "pygreat" ];
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

  nativeCheckInputs = [ pytestCheckHook ];

  # Build the per-revision FPGA bitstreams in parallel (see build_gateware.py).
  enableParallelBuilding = true;

  pythonImportsCheck = [ "cynthion" ];

  postInstall =
    let
      assets = "$out/${python.sitePackages}/cynthion/assets";
    in
    ''
      # Build a bitstream set per hardware revision into assets/, where
      # `cynthion flash` looks for them.
      export BUILD_GATEWARE_MAX_WORKERS="''${NIX_BUILD_CORES:-1}"
      PYTHONPATH="$out/${python.sitePackages}''${PYTHONPATH:+:$PYTHONPATH}" \
        python ${./build_gateware.py} "${assets}"

      # Install the moondancer SoC firmware for `cynthion flash facedancer`.
      install -Dm444 ${moondancer}/bin/moondancer.bin "${assets}/moondancer.bin"

      # Make udev rules available for NixOS option services.udev.packages
      install -Dm444 \
        -t $out/lib/udev/rules.d \
        build/lib/cynthion/assets/54-cynthion.rules
    '';

  passthru = { inherit moondancer; };

  meta = {
    description = "Python package and utilities for the Great Scott Gadgets Cynthion USB Test Instrument";
    homepage = "https://github.com/greatscottgadgets/cynthion";
    changelog = "https://github.com/greatscottgadgets/cynthion/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ carlossless ];
  };
}
