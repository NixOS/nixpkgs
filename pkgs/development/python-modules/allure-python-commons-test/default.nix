{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyhamcrest,
  python,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "allure-python-commons-test";
  version = "2.16.0";
  pyproject = true;

  src = fetchPypi {
    pname = "allure_python_commons_test";
    inherit version;
    hash = "sha256-otfGxWNnbMUGuQcqsroOOfiqhCQqe25c39Ur57ek2og=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setuptools_scm<10" "setuptools_scm"
  '';

  build-system = [ setuptools-scm ];

  dependencies = [ pyhamcrest ];

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
