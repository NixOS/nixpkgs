{ lib
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "80";
=======
  version = "78";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.9";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "boxine";
    repo = "bx_py_utils";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-ih0tqT+3fTTgncXz4bneo4OGT0jVhybdADTy1de5VqI=";
  };

  postPatch = ''
    rm bx_py_utils_tests/publish.py
  '';

=======
    hash = "sha256-dMcbv/qf+8Qzu47MVFU2QUviT/vjKsHp+45F/6NOlWo=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  disabledTests = [
    # too closely affected by bs4 updates
    "test_pretty_format_html"
    "test_assert_html_snapshot_by_css_selector"
  ];

  disabledTestPaths = [
    "bx_py_utils_tests/tests/test_project_setup.py"
  ] ++ lib.optionals stdenv.isDarwin [
    # processify() doesn't work under darwin
    # https://github.com/boxine/bx_py_utils/issues/80
    "bx_py_utils_tests/tests/test_processify.py"
=======
  disabledTestPaths = [
    "bx_py_utils_tests/tests/test_project_setup.py"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = {
    description = "Various Python utility functions";
    homepage = "https://github.com/boxine/bx_py_utils";
<<<<<<< HEAD
    changelog = "https://github.com/boxine/bx_py_utils/releases/tag/${src.rev}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
