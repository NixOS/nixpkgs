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
<<<<<<< HEAD
  version = "2.15.2";
=======
  version = "2.15.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  src = fetchPypi {
    pname = "allure_python_commons_test";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-SAjo9rM1zXAVBMD1c+rkMcR8zCeW1L3CErR/SxwjnXg=";
=======
    hash = "sha256-5l/9K6ToYEGaYXOmVxB188wu9gQ+2cMHxfVNlX8Rz9g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Just pack of hamcrest matchers for validation result in allure2 json format";
    homepage = "https://github.com/allure-framework/allure-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ evanjs ];
=======
  meta = with lib; {
    description = "Just pack of hamcrest matchers for validation result in allure2 json format";
    homepage = "https://github.com/allure-framework/allure-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ evanjs ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
