{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  attrs,
  pluggy,
  six,
  allure-python-commons-test,
  setuptools-scm,
  python,
}:

buildPythonPackage rec {
  pname = "allure-python-commons";
  version = "2.15.3";
  pyproject = true;

  src = fetchPypi {
    pname = "allure_python_commons";
    inherit version;
    hash = "sha256-tCqW1gdvsyPJ5DZF37hMBXT2utCg4AXZJWQBXNFy1WQ=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    attrs
    pluggy
  ];

  pythonImportsCheck = [
    "allure"
    "allure_commons"
  ];

  meta = {
    description = "Common engine for all modules. It is useful for make integration with your homemade frameworks";
    homepage = "https://github.com/allure-framework/allure-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ evanjs ];
  };
}
