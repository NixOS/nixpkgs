{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, behave
, allure-python-commons
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "allure-behave";
  version = "2.13.2";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mxXb7+1tvf5EmVbD6eOmGfza9lAjbEVoxWZBSeZmPxQ=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  pythonImportsCheck = [ "allure_behave" ];

  propagatedBuildInputs = [
    allure-python-commons
    behave
  ];

  meta = with lib; {
    description = "Allure behave integration.";
    homepage = "https://github.com/allure-framework/allure-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
