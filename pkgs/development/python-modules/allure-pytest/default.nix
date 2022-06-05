{ lib
, fetchPypi
, buildPythonPackage
, six
, pythonOlder
, allure-python-commons
, pytest
, pytestCheckHook
, pytest-check
, pytest-flakes
, pytest-lazy-fixture
, pytest-rerunfailures
, pytest-xdist
, pyhamcrest
, mock
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "allure-pytest";
  version = "2.9.45";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18ys5gi64jlfya6a7shj5lqhwc6cplwgyq3s2n5mg5x513g0yqi0";
  };

  buildInputs = [
    pytest
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  pythonImportsCheck = [ "allure_pytest" ];

  propagatedBuildInputs = [
    allure-python-commons
    six
  ];

  checkInputs = [
    pyhamcrest
    mock
    pytestCheckHook
    pytest-check
    pytest-flakes
    pytest-lazy-fixture
    pytest-rerunfailures
    pytest-xdist
  ];

  pytestFlagsArray = [
    "--basetemp"
    "$(mktemp -d)"
    "--alluredir"
    "$(mktemp -d allure-results.XXXXXXX)"
    "-W"
    "ignore::pytest.PytestExperimentalApiWarning"
    "-p"
    "pytester"
  ];

  # we are skipping some of the integration tests for now
  disabledTests = [
    "test_pytest_check"
    "test_pytest_check_example"
    "test_select_by_testcase_id_test"
  ];

  meta = with lib; {
    description = "Allure pytest integration. It's developed as pytest plugin and distributed via pypi";
    homepage = "https://github.com/allure-framework/allure-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ evanjs ];
  };
}
