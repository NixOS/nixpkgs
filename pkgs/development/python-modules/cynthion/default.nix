{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

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
buildPythonPackage rec {
  pname = "cynthion";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "cynthion";
    tag = version;
    hash = "sha256-ebd2L7o6GO57TpwJ7+MOhVSb+I/E8kD7d7DqPj4B3FM=";
  };

  sourceRoot = "${src.name}/cynthion/python";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [ udevCheckHook ];

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

  pythonImportsCheck = [ "cynthion" ];

  # Make udev rules available for NixOS option services.udev.packages
  postInstall = ''
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
