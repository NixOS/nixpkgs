{
  lib,
  buildPythonPackage,
  fetchPypi,
  importlib-metadata,
  psutil,
  setuptools,
  pip,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "helpdev";
  version = "0.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-u2KnmsusFB2t9Cyt65K7dFDdGLmCSmIEO2oLFJGQ2z0=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace helpdev/__init__.py \
      --replace-fail "'pip'," "'${lib.getExe pip}',"
  '';

  dependencies = [
    importlib-metadata
    psutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Extracts information about the Python environment easily";
    mainProgram = "helpdev";
    license = lib.licenses.mit;
  };
})
