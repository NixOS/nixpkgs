{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  python-dateutil,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "freezegun";
  version = "1.5.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rHdCpsxsJaLDXpKS39VUuJe1F9LewmiRoujevyBcuUo=";
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

  meta = {
    description = "Library that allows your Python tests to travel through time";
    homepage = "https://github.com/spulec/freezegun";
    changelog = "https://github.com/spulec/freezegun/blob/${version}/CHANGELOG";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
