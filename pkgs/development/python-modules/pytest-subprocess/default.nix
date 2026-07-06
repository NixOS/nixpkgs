{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  pytest,
  pytestCheckHook,
  docutils,
  pygments,
  pytest-rerunfailures,
  pytest-asyncio,
  anyio,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pytest-subprocess";
  version = "1.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aklajnert";
    repo = "pytest-subprocess";
    tag = version;
    hash = "sha256-TFTY6enuyzQx0U+qHVde71VHqVa0oEGbSJUwhMAsI7Q=";
  };

  patches = [
    # https://github.com/aklajnert/pytest-subprocess/pull/202
    (fetchpatch {
      name = "fix-test_any_matching_program.patch";
      url = "https://github.com/aklajnert/pytest-subprocess/commit/14c571b9b72a7b7e429189a9455fc715e6f0dbce.patch";
      hash = "sha256-xDj5KSyv+JXRuMoUKpIr5oDN9y8V14LApRXbzNi9HI8=";
    })
  ];

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    pytestCheckHook
    docutils
    pygments
    pytest-rerunfailures
    pytest-asyncio
    anyio
    typing-extensions
  ];

  meta = {
    description = "Plugin to fake subprocess for pytest";
    homepage = "https://github.com/aklajnert/pytest-subprocess";
    changelog = "https://github.com/aklajnert/pytest-subprocess/blob/${src.tag}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
