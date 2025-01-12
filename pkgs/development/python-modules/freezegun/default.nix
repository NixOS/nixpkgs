{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  python-dateutil,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "freezegun";
  version = "1.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sp3t/NptXo4IPOcbK1QnU61Iz+xEA3s/x5cC4pgKiek=";
  };

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.13") [
    # https://github.com/spulec/freezegun/issues/547
    "test_method_decorator_works_on_unittest_kwarg_frozen_time"
    "test_method_decorator_works_on_unittest_kwarg_frozen_time_with_func"
    "test_method_decorator_works_on_unittest_kwarg_hello"
  ];

  pythonImportsCheck = [ "freezegun" ];

  meta = with lib; {
    description = "Library that allows your Python tests to travel through time";
    homepage = "https://github.com/spulec/freezegun";
    changelog = "https://github.com/spulec/freezegun/blob/${version}/CHANGELOG";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
