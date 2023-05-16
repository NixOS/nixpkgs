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
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-netdata";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-XWlUSKGgndHtJjzA0mYvhCkJsRJ1SUbl8DGdmyFUmoo=";
=======
    rev = version;
    hash = "sha256-vrXXvCoZ1jErlxTcjGbtA8Uio7UDxnt3aNb9FQ0PkrU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/home-assistant-ecosystem/python-netdata/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
