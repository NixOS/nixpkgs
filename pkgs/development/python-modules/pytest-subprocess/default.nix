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
}:

buildPythonPackage rec {
  pname = "pytest-subprocess";
  version = "1.5.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aklajnert";
    repo = "pytest-subprocess";
    rev = "refs/tags/${version}";
    hash = "sha256-wEPIRWEwAiHSpcu9FMtkpAxqz64csT9AO27NDax3zNY=";
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
  ];

  pytestFlagsArray = [ "-W ignore::DeprecationWarning" ];

  meta = with lib; {
    description = "Plugin to fake subprocess for pytest";
    homepage = "https://github.com/aklajnert/pytest-subprocess";
    changelog = "https://github.com/aklajnert/pytest-subprocess/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
