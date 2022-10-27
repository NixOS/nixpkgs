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
  version = "2.10.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BzDu/LJBstuchkvUAeCDSIDIiFLZmC4y0s3d+1paGxs=";
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
