{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools-scm,

  # dependencies
  fastcrc,
  msgspec,
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "apycula";
  version = "0.31";
  pyproject = true;

  # The Pypi archive contains necessary files generated with proprietary tools.
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-77pr4HbS2adFeEI3Q3KzcCfJMi4UomOtKnuGAxobxF0=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    fastcrc
    msgspec
    numpy
  ];

  # Tests require a physical FPGA
  doCheck = false;

  pythonImportsCheck = [ "apycula" ];

  meta = {
    description = "Open Source tools for Gowin FPGAs";
    homepage = "https://github.com/YosysHQ/apicula";
    changelog = "https://github.com/YosysHQ/apicula/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ newam ];
  };
})
