{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  codec2,
  cython,
  numpy_1,
}:

buildPythonPackage rec {
  pname = "pycodec2";
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eDvz1EkdEaYily25MX2xyUCPrUjT1dtHrRROVaVkkHA=";
  };

  build-system = [
    setuptools
    cython
    numpy_1
  ];

  dependencies = [
    codec2
    numpy_1
  ];

  meta = {
    description = "Cython wrapper for Codec 2";
    homepage = "https://github.com/gregorias/pycodec2";
    license = lib.licenses.bsd3;
  };
}
