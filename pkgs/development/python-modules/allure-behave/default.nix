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
  version = "2.9.45";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-aK0SgQIXpuUoSTz8jg5IPKQM2Xvk2EfkSGigsy/GFNo=";
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
