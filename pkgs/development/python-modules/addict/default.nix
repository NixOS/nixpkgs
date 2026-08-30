{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "addict";
  version = "2.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-s7IhDg4GeigfVkbIxduS6ZtyMeqLDrX3Tb354lnU5JQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "addict" ];

  meta = {
    description = "Module that exposes a dictionary subclass that allows items to be set like attributes";
    homepage = "https://github.com/mewwts/addict";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
