{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dicttoxml2";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Z8tynzN911KAjAIbcMjfijT4S54RGl26o34ADur01GI=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "dicttoxml2" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Converts a Python dictionary or other native data type into a valid XML string";
    homepage = "https://pypi.org/project/dicttoxml2/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
