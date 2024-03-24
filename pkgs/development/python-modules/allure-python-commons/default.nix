{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, attrs
, pluggy
, six
, allure-python-commons-test
, setuptools-scm
, python
}:

buildPythonPackage rec {
  pname = "allure-python-commons";
  version = "2.13.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KiLGBxvTcAuzgL9SiNioFpe6Po5JGINqpMxLSxepmn4=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [ attrs pluggy six allure-python-commons-test ];

  checkPhase = ''
    ${python.interpreter} -m doctest ./src/utils.py
    ${python.interpreter} -m doctest ./src/mapping.py
  '';

  pythonImportsCheck = [ "allure" "allure_commons" ];

  meta = with lib; {
    description = "Common engine for all modules. It is useful for make integration with your homemade frameworks";
    homepage = "https://github.com/allure-framework/allure-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ evanjs ];
  };
}
