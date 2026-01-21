{
  lib,
  fetchPypi,
  buildPythonPackage,
  attrs,
  pluggy,
  six,
  pyhamcrest,
  setuptools-scm,
  python,
}:

buildPythonPackage rec {
  pname = "allure-python-commons-test";
  version = "2.15.3";
  pyproject = true;

  src = fetchPypi {
    pname = "allure_python_commons_test";
    inherit version;
    hash = "sha256-eRjjsxiXm/7nMyaJS5pXhpNmrjOhnd1o7+F9ZwGzI/I=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    attrs
    pluggy
    six
    pyhamcrest
  ];

  checkPhase = ''
    ${python.interpreter} -m doctest ./src/container.py
    ${python.interpreter} -m doctest ./src/report.py
    ${python.interpreter} -m doctest ./src/label.py
    ${python.interpreter} -m doctest ./src/result.py
  '';

  pythonImportsCheck = [ "allure_commons_test" ];

  meta = {
    description = "Just pack of hamcrest matchers for validation result in allure2 json format";
    homepage = "https://github.com/allure-framework/allure-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ evanjs ];
  };
}
