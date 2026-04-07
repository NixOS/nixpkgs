{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  httpx,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage rec {
  pname = "netdata";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-netdata";
    tag = version;
    hash = "sha256-rffqpvqVvCi7CKjDchgRzUWDNxsA7C37UHvbELewR0E=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    httpx
    yarl
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "netdata" ];

  meta = {
    description = "Python API for interacting with Netdata";
    homepage = "https://github.com/home-assistant-ecosystem/python-netdata";
    changelog = "https://github.com/home-assistant-ecosystem/python-netdata/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
