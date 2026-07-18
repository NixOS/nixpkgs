{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  future,
  ipython,
  numpy,
  pyserial,
  pyusb,
  pytestCheckHook,
  udevCheckHook,
}:

buildPythonPackage rec {
  pname = "rfcat";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonAtLeast "3.13"; # rfcat only supports up to python312 due to the limitation of future-1.0.0

  src = fetchFromGitHub {
    owner = "atlas0fd00m";
    repo = "rfcat";
    tag = "v${version}";
    hash = "sha256-hdRsVbDXRC1EOhBoFJ9T5ZE6hwOgDWSdN5sIpxJ0x3E=";
  };

  propagatedBuildInputs = [
    future
    ipython
    numpy
    pyserial
    pyusb
  ];

  nativeBuildInputs = [
    udevCheckHook
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/etc/udev/rules.d
    cp etc/udev/rules.d/20-rfcat.rules $out/etc/udev/rules.d
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rflib" ];

  meta = {
    description = "Swiss Army knife of sub-GHz ISM band radio";
    homepage = "https://github.com/atlas0fd00m/rfcat";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    changelog = "https://github.com/atlas0fd00m/rfcat/releases/tag/v${version}";
  };
}
