{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, attrs
, pluggy
, six
, pyhamcrest
, setuptools-scm
, python
}:

buildPythonPackage rec {
  pname = "allure-python-commons-test";
  version = "2.12.0";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TaeQF9EZ5tLMmVSwnWgrxsRz5lh0O3BZLLEUawd8BeI=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [ attrs pluggy six pyhamcrest ];

  checkPhase = ''
    ${python.interpreter} -m doctest ./src/container.py
    ${python.interpreter} -m doctest ./src/report.py
    ${python.interpreter} -m doctest ./src/label.py
    ${python.interpreter} -m doctest ./src/result.py
  '';

  pythonImportsCheck = [ "allure_commons_test" ];

  meta = with lib; {
    description = "Just pack of hamcrest matchers for validation result in allure2 json format";
    homepage = "https://github.com/allure-framework/allure-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ evanjs ];
  };
}
