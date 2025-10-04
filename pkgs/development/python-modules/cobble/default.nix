{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "cobble";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "python-cobble";
    tag = version;
    hash = "sha256-xi6cCSUnMYc5Tp6+TQlC9Oo9kpam5C7QGCul/IoTW1k=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "cobble" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests.py" ];

  disabledTests = [
    # Broken tests
    #
    # left = "Can't instantiate abstract class Evaluator with abstract method visit_add"
    # right = "Can't instantiate abstract class Evaluator without an implementation for abstract method 'visit_add'"
    "test_error_if_visitor_is_missing_methods"
    # left = "Can't instantiate abstract class Evaluator with abstract method visit_literal"
    # right = "Can't instantiate abstract class Evaluator without an implementation for abstract method 'visit_literal'"
    "test_sub_sub_classes_are_included_in_abc"
  ];

  passthru.updateScripts = gitUpdater { };

  meta = {
    description = "Create Python data objects";
    homepage = "https://github.com/mwilliamson/python-cobble";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
