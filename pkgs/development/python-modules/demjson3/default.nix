{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "demjson3";
  version = "3.0.6";
  format = "setuptools";

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-N8g7DG6wjSXe/IjfCipIddWKeAmpZQvW7uev2AU826w=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "demjson3" ];

  meta = {
    description = "Encoder/decoder and lint/validator for JSON (JavaScript Object Notation)";
    mainProgram = "jsonlint";
    homepage = "https://github.com/nielstron/demjson3/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
