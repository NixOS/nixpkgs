{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  beautifulsoup4,
  boto3,
  freezegun,
  hatchling,
  lxml,
  openpyxl,
  parameterized,
  pdoc,
  pytestCheckHook,
  requests-mock,
  typeguard,
}:

buildPythonPackage rec {
  pname = "bx-py-utils";
  version = "114";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "boxine";
    repo = "bx_py_utils";
    tag = "v${version}";
    hash = "sha256-AAn1e5HuSngEnCoCpOvVjxavZbiH2YL+38gXxhqLLBo=";
  };

  postPatch = ''
    rm bx_py_utils_tests/publish.py
  '';

  build-system = [ hatchling ];

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
    freezegun
    lxml
    openpyxl
    parameterized
    pdoc
    pytestCheckHook
    requests-mock
    typeguard
  ];

  disabledTests = [
    # too closely affected by bs4 updates
    "test_pretty_format_html"
    "test_assert_html_snapshot_by_css_selector"
    # test accesses the internet
    "test_happy_path"
  ];

  disabledTestPaths = [
    # depends on cli-base-utilities, which depends on bx-py-utils
    "bx_py_utils_tests/tests/test_project_setup.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # processify() doesn't work under darwin
    # https://github.com/boxine/bx_py_utils/issues/80
    "bx_py_utils_tests/tests/test_processify.py"
  ];

  meta = {
    description = "Various Python utility functions";
    mainProgram = "bx_py_utils";
    homepage = "https://github.com/boxine/bx_py_utils";
    changelog = "https://github.com/boxine/bx_py_utils/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
