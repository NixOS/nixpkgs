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
  version = "1.3.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "opencc";
    inherit version;
    hash = "sha256-aJLuP4/MWZLw6fkNvxd8jaVmYg+Dw/IEAlcpPxYUGzM=";
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
