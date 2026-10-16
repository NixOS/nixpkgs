{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  glibcLocales,
  gnureadline,
  pyperclip,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  rich-argparse,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "cmd2";
  version = "3.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-cmd2";
    repo = "cmd2";
    tag = finalAttrs.version;
    hash = "sha256-dntUbxlMVlss6TN8IhEaWcANqiqWgqxT35bGY7cWjcE=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    pyperclip
    rich-argparse
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin gnureadline;

  doCheck = true;

  nativeCheckInputs = [
    glibcLocales
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
  ];

  disabledTests = [
    # Don't require vim for tests, it causes lots of rebuilds
    "test_find_editor_not_specified"
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
