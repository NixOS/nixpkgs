{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libusb1,
  importlib-resources,
  setuptools,
  setuptools-scm,
  tomli,
  wheel,
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
    wheel
    tomli
  ];

  propagatedBuildInputs = [
    libusb1
    importlib-resources
  ];

  meta = {
    description = "Python package for simplified libusb distribution and usage with pyOCD";
    homepage = "https://github.com/pyocd/libusb-package";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brianmcgillion ];
    platforms = lib.platforms.linux;
  };
}
