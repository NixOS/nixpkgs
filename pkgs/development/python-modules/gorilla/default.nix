{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gorilla";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AFq4hTsDcWKnx3u4JGBMbggYeO4DwJrQHvQXRIVgGdM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gorilla" ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [ "test_find_patches_2" ];

  meta = with lib; {
    description = "Convenient approach to monkey patching";
    homepage = "https://github.com/christophercrouzet/gorilla";
    changelog = "https://github.com/christophercrouzet/gorilla/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ tbenst ];
  };
}
