{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "anthemav";
  version = "1.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nugget";
    repo = "python-anthemav";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZjAt4oODx09Qij0PwBvLCplSjwdBx2fReiwjmKhdPa0=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "anthemav" ];

  meta = with lib; {
    description = "Python asyncio module to interface with Anthem AVM and MRX receivers";
    mainProgram = "anthemav_monitor";
    homepage = "https://github.com/nugget/python-anthemav";
    changelog = "https://github.com/nugget/python-anthemav/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
