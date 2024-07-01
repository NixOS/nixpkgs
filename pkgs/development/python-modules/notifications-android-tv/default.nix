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
  version = "1.0.0";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "engrbm87";
    repo = "notifications_android_tv";
    rev = version;
    hash = "sha256-Xr+d2uYzgFp/Fb00ymov02+GYnwjGc3FbJ/rIvQXzCE=";
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
