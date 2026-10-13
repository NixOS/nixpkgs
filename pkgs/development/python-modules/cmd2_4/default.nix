{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  glibcLocales,
  prompt-toolkit,
  pyperclip,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  rich,
  rich-argparse,
  setuptools-scm,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "cmd2";
  version = "4.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-cmd2";
    repo = "cmd2";
    tag = finalAttrs.version;
    hash = "sha256-htU0/cFg157tOWBdLwNvnHwvoXizJUIBcp2jgzFqQrQ=";
  };

  pythonRelaxDeps = [ "prompt-toolkit" ];

  build-system = [ setuptools-scm ];

  dependencies = [
    prompt-toolkit
    pyperclip
    rich
    rich-argparse
  ];

  doCheck = true;

  nativeCheckInputs = [
    glibcLocales
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
  ];

  disabledTests = [
    # Don't require an editor just to be able to discover it
    "test_find_editor_not_specified"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # does not work under darwin sandbox
    "test_history_file_bad_compression"
    "test_history_file_bad_json"
    "test_path_completion_complete_user"
  ];

  pythonImportsCheck = [ "cmd2" ];

  meta = {
    description = "Enhancements for standard library's cmd module";
    homepage = "https://github.com/python-cmd2/cmd2";
    changelog = "https://github.com/python-cmd2/cmd2/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
  };
})
