{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  gcc,
  wirelesstools,
  isPyPy,
}:

buildPythonPackage (finalAttrs: {
  pname = "basiciw";
  version = "0.2.2";
  pyproject = true;

  __structuredAttrs = true;

  disabled = isPyPy;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-S/vpNoJyc5evFEtrsif6BKkc1Qc9z4ory9RNujd1Vao=";
  };

  build-system = [ setuptools ];

  buildInputs = [ gcc ];
  dependencies = [ wirelesstools ];

  pythonImportsCheck = [ "basiciw" ];

  meta = {
    description = "Get info about wireless interfaces using libiw";
    homepage = "https://github.com/enkore/basiciw";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
    hasNoMaintainersButDependents = true;
  };
})
