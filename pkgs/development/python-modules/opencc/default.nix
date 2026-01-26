{
  lib,
  buildPythonPackage,
  cmake,
  fetchPypi,
  setuptools,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "opencc";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-K7kTx+04hGaybTivTIxLtBndtQMjXQcPDuGySZjvi8o=";
  };

  build-input = [
    cmake
    setuptools
    wheel
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "opencc" ];

  meta = {
    description = "Python bindings for OpenCC (Conversion between Traditional and Simplified Chinese)";
    homepage = "https://github.com/BYVoid/OpenCC";
    changelog = "https://github.com/BYVoid/OpenCC/releases/tag/ver.${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ siraben ];
  };
})
