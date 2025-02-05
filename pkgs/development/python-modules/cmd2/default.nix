{
  lib,
  stdenv,
  attrs,
  buildPythonPackage,
  colorama,
  fetchPypi,
  glibcLocales,
  importlib-metadata,
  pyperclip,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  typing-extensions,
  wcwidth,
}:

buildPythonPackage rec {
  pname = "cmd2";
  version = "2.5.9";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CbsTY3gyvIGKrVV3zN9dvrDJ++W5QS/3jVCE94Rvg6s=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Fake the impure dependencies pbpaste and pbcopy
    mkdir bin
    echo '#!${stdenv.shell}' > bin/pbpaste
    echo '#!${stdenv.shell}' > bin/pbcopy
    chmod +x bin/{pbcopy,pbpaste}
    export PATH=$(realpath bin):$PATH
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    attrs
    colorama
    pyperclip
    wcwidth
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

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
