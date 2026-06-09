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
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "opencc";
    inherit version;
    hash = "sha256-K7kTx+04hGaybTivTIxLtBndtQMjXQcPDuGySZjvi8o=";
  };

  nativeBuildInputs = [
    cmake
    setuptools
    wheel
  ];

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
