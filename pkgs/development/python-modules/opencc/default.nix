{
  lib,
  buildPythonPackage,
  fetchPypi,
  cmake,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "opencc";
  version = "1.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "opencc";
    inherit version;
    hash = "sha256-osWCFWJqxRMcXbJ3dmZ41VL8KW6eApnvGDy2fBp/MOc=";
  };

  build-system = [
    setuptools
    wheel
  ];

  nativeBuildInputs = [ cmake ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [
    "opencc"
  ];

  meta = {
    description = "Python bindings for OpenCC (Conversion between Traditional and Simplified Chinese)";
    homepage = "https://github.com/BYVoid/OpenCC";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ siraben ];
  };
}
