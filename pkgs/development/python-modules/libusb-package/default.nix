{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyusb,
  replaceVars,
  setuptools,
  setuptools-scm,
  stdenv,
  tomli,
  libusb1,
}:

buildPythonPackage rec {
  pname = "libusb-package";
  version = "1.0.30.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyocd";
    repo = "libusb-package";
    tag = "v${version}";
    hash = "sha256-/Q1VovC2864Xu+LidL72Rh/FfyZqSJ8m21WS+FBkOrU=";
  };

  patches = [
    (replaceVars ./hardcode-libusb1-path.patch {
      libusb1 = "${lib.getLib libusb1}/lib/libusb-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
    tomli
  ];

  nativeCheckInputs = [
    pyusb
  ];

  checkPhase = ''
    runHook preCheck

    python test.py

    runHook postCheck
  '';

  meta = {
    description = "Python package for simplified libusb distribution and usage with pyOCD";
    homepage = "https://github.com/pyocd/libusb-package";
    changelog = "https://github.com/pyocd/libusb-package/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brianmcgillion ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
