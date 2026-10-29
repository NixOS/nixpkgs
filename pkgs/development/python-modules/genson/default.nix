{
  buildPythonPackage,
  fetchPypi,
  jsonschema,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "genson";
  version = "1.4.0";
  pyproject = true;

  # Using Python repository source due to missing genson.schema in setup tools.
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-vH8cG66HohykTYEUmuyVo/RGjWdt6biwjKoGTzxQs9o=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    jsonschema
    pytestCheckHook
  ];

  disabledTests = [
    "test_no_input"
  ];

  pythonImportsCheck = [ "genson" ];

  meta = {
    description = "GenSON a JSON Schema generator built in Python";
    homepage = "https://github.com/wolverdude/GenSON";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "genson";
  };
})
