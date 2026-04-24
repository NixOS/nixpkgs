{
  buildPythonPackage,
  chardet,
  fetchPypi,
  flit-core,
  lib,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "encutils";
  version = "1.0.0";
  pyproject = true;

  # pyproject.toml on GitHub uses coherent.build as build-system
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-OOylrxjOur2L5DwX8UydP7uoPMX3rI46schuJMSyuRo=";
  };

  build-system = [ flit-core ];

  dependencies = [
    chardet
  ];

  pythonImportsCheck = [ "encutils" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Collection of helper functions to detect encodings of text files";
    homepage = "https://github.com/coherent-oss/encutils";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
