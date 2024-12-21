{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  poetry-core,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "notifications-android-tv";
  version = "1.2.2";
  format = "pyproject";
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "engrbm87";
    repo = "notifications_android_tv";
    rev = "refs/tags/${version}";
    hash = "sha256-JUvxxVCiQtywAWU5AYnPm4SueIWIXkzLxPYveVXpc2E=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ httpx ];

  pythonImportsCheck = [ "notifications_android_tv" ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    pytest-asyncio
    pytest-httpx
  ];

  meta = with lib; {
    description = "Python API for sending notifications to Android/Fire TVs";
    homepage = "https://github.com/engrbm87/notifications_android_tv";
    changelog = "https://github.com/engrbm87/notifications_android_tv/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dominikh ];
  };
}
