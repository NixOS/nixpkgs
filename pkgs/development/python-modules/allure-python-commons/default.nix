{
  lib,
  fetchPypi,
  buildPythonPackage,
  attrs,
  pluggy,
  six,
  allure-python-commons-test,
  setuptools-scm,
  python,
}:

buildPythonPackage rec {
  pname = "allure-python-commons";
  version = "2.16.0";
  pyproject = true;

  src = fetchPypi {
    pname = "allure_python_commons";
    inherit version;
    hash = "sha256-7NySuv6gdLq5a18sTrMQCCU0AYj1rs5giugOztcJs28=";
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
