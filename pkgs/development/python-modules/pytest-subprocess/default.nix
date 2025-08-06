{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
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
  version = "1.5.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aklajnert";
    repo = "pytest-subprocess";
    tag = version;
    hash = "sha256-3vBYOk/P78NOjAbs3fT6py5QOOK3fX+AKtO4j5vxZfk=";
  };

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

  pytestFlags = [ "-Wignore::DeprecationWarning" ];

  meta = with lib; {
    description = "Plugin to fake subprocess for pytest";
    homepage = "https://github.com/aklajnert/pytest-subprocess";
    changelog = "https://github.com/aklajnert/pytest-subprocess/blob/${src.tag}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
