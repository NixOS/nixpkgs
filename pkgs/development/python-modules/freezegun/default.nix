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
<<<<<<< HEAD
  version = "1.5.5";
=======
  version = "1.5.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-rHdCpsxsJaLDXpKS39VUuJe1F9LewmiRoujevyBcuUo=";
=======
    hash = "sha256-eYuTcv3U2QfzPotqWLxk5oLZ/6jUlM5g94AZfugfrtE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Library that allows your Python tests to travel through time";
    homepage = "https://github.com/spulec/freezegun";
    changelog = "https://github.com/spulec/freezegun/blob/${version}/CHANGELOG";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library that allows your Python tests to travel through time";
    homepage = "https://github.com/spulec/freezegun";
    changelog = "https://github.com/spulec/freezegun/blob/${version}/CHANGELOG";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
