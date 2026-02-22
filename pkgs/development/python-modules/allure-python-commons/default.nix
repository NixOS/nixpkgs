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
  version = "2.15.0";
  pyproject = true;

  src = fetchPypi {
    pname = "allure_python_commons";
    inherit version;
    hash = "sha256-T2Oci7S3nfDZTxuqiHgsk5m+P0X9g5rlg6MUpdRRuXg=";
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
