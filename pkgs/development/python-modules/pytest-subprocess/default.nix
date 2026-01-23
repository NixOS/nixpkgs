{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
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
  version = "1.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aklajnert";
    repo = "pytest-subprocess";
    tag = version;
    hash = "sha256-3vBYOk/P78NOjAbs3fT6py5QOOK3fX+AKtO4j5vxZfk=";
  };

  patches = lib.optionals (pythonAtLeast "3.13") [
    (fetchpatch {
      # python 3.14 compat
      # the patch however breaks 3.12:
      # https://github.com/aklajnert/pytest-subprocess/issues/192
      url = "https://github.com/aklajnert/pytest-subprocess/commit/be30d9a94ba45afb600717e3fcd95b8b2ff2c60e.patch";
      hash = "sha256-TYk/Zu2MF+ROEKTgZI1rzA2MlW2it++xElfGZS0Dn5s=";
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

  pytestFlags = [ "-Wignore::DeprecationWarning" ];

  meta = {
    description = "Plugin to fake subprocess for pytest";
    homepage = "https://github.com/aklajnert/pytest-subprocess";
    changelog = "https://github.com/aklajnert/pytest-subprocess/blob/${src.tag}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
