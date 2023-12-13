{ lib
, allure-python-commons
, buildPythonPackage
, fetchPypi
, pytest
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "allure-pytest";
  version = "2.13.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IiQxWejsgc4rUlS0ATgCGYghsbQvEY9p1KKJOWYHx7M=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    allure-python-commons
  ];

  # Tests were moved to the meta package
  doCheck = false;

  pythonImportsCheck = [
    "allure_pytest"
  ];

  meta = with lib; {
    description = "Allure integrations for Python test frameworks";
    homepage = "https://github.com/allure-framework/allure-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ evanjs ];
  };
}
