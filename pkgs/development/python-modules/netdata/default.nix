{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, httpx
, pytest-asyncio
, pytest-httpx
, pytestCheckHook
, yarl
}:

buildPythonPackage rec {
  pname = "netdata";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-netdata";
    rev = "refs/tags/${version}";
    hash = "sha256-XWlUSKGgndHtJjzA0mYvhCkJsRJ1SUbl8DGdmyFUmoo=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    httpx
    yarl
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "netdata"
  ];

  meta = with lib; {
    description = "Python API for interacting with Netdata";
    homepage = "https://github.com/home-assistant-ecosystem/python-netdata";
    changelog = "https://github.com/home-assistant-ecosystem/python-netdata/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
