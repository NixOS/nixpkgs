{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  tomli,
  importlib-resources,
  libusb1,
}:

buildPythonPackage rec {
  pname = "libusb-package";
  version = "1.0.26.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyocd";
    repo = "libusb-package";
    tag = "v${version}";
    hash = "sha256-4zTyaidpSlledTcEztWzRgwj43oNV7xWrhMXCE9Qz3k=";
  };

  build-system = [
    setuptools
    setuptools-scm
    tomli
  ];

  dependencies = [
    importlib-resources
    libusb1
  ];

  meta = {
    description = "Python package for simplified libusb distribution and usage with pyOCD";
    homepage = "https://github.com/pyocd/libusb-package";
    changelog = "https://github.com/pyocd/libusb-package/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brianmcgillion ];
    platforms = lib.platforms.linux;
  };
}
