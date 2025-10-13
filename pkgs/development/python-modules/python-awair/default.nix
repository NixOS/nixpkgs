{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  voluptuous,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "python-awair";
  version = "0.2.4";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ahayworth";
    repo = "python_awair";
    rev = version;
    hash = "sha256-zdZyA6adM4bfEYupdZl7CzMjwyfRkQBrntNh0MusynE=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    voluptuous
  ];

  # Failed: async def functions are not natively supported.
  doCheck = false;

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
    vcrpy
  ];

  pythonImportsCheck = [ "python_awair" ];

  meta = with lib; {
    description = "Python library for the Awair API";
    homepage = "https://github.com/ahayworth/python_awair";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
