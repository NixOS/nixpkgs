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
  version = "2.12.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1cNi3QEWfwhjMYIumxkS1Ob9bLwtGgBt0EjnfoKnrnM=";
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
