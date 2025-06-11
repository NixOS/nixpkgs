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
  version = "2.13.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pWkLVfBrLEhdhuTE95K3aqrhEY2wEyo5uRzuJC3ngjE=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Just pack of hamcrest matchers for validation result in allure2 json format";
    homepage = "https://github.com/allure-framework/allure-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ evanjs ];
  };
}
