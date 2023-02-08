{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, beautifulsoup4
, boto3
, lxml
, pdoc
, pytestCheckHook
, requests-mock
}:

buildPythonPackage rec {
  pname = "bx-py-utils";
  version = "75";

  disabled = pythonOlder "3.9";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "boxine";
    repo = "bx_py_utils";
    rev = "refs/tags/v${version}";
    hash = "sha256-+RHt5QTXxuaY1tDe1M66TrQfT9I7X56oVQAW36mzSwM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [
    "bx_py_utils.anonymize"
    "bx_py_utils.auto_doc"
    "bx_py_utils.compat"
    "bx_py_utils.dict_utils"
    "bx_py_utils.environ"
    "bx_py_utils.error_handling"
    "bx_py_utils.file_utils"
    "bx_py_utils.graphql_introspection"
    "bx_py_utils.hash_utils"
    "bx_py_utils.html_utils"
    "bx_py_utils.iteration"
    "bx_py_utils.path"
    "bx_py_utils.processify"
    "bx_py_utils.rison"
    "bx_py_utils.stack_info"
    "bx_py_utils.string_utils"
    "bx_py_utils.test_utils"
    "bx_py_utils.text_tools"
  ];

  nativeCheckInputs = [
    beautifulsoup4
    boto3
    lxml
    pdoc
    pytestCheckHook
    requests-mock
  ];

  disabledTestPaths = [
    "bx_py_utils_tests/tests/test_project_setup.py"
  ];

  meta = {
    description = "Various Python utility functions";
    homepage = "https://github.com/boxine/bx_py_utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
