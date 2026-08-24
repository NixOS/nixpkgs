{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  glibcLocales,
  gnureadline,
  prompt-toolkit,
  pyperclip,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  rich-argparse,
  setuptools-scm,
  wcwidth,
}:

buildPythonPackage (finalAttrs: {
  pname = "cmd2";
  version = "4.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-iQIWA6GM60FgDS8CtAxd9NN+QRAnMI6aWHFL4fOla2s=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    prompt-toolkit
    pyperclip
    rich-argparse
    wcwidth
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin gnureadline;

  nativeCheckInputs = [
    glibcLocales
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
  ];

  disabledTests = [
    # Don't require vim for tests, it causes lots of rebuilds
    "test_find_editor_not_specified"
    "test_transcript"
    # Removed upstream after rich 15 update
    "test_from_ansi_wrapper"
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
