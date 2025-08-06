{
  lib,
  stdenv,
  attrs,
  buildPythonPackage,
  colorama,
  fetchPypi,
  glibcLocales,
  gnureadline,
  pyperclip,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  wcwidth,
}:

buildPythonPackage rec {
  pname = "cmd2";
  version = "2.6.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZQpYkr8psjPT1ndbXjzIE2SM/w15E09weYH2a6rtn0I=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    attrs
    colorama
    pyperclip
    wcwidth
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
    "test_transcript"
  ];

  pythonImportsCheck = [ "cmd2" ];

  meta = with lib; {
    description = "Enhancements for standard library's cmd module";
    homepage = "https://github.com/python-cmd2/cmd2";
    changelog = "https://github.com/python-cmd2/cmd2/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ teto ];
  };
}
