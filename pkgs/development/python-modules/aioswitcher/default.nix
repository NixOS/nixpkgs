{ lib
, aiohttp
, asynctest
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytest-sugar
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aioswitcher";
  version = "1.2.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "TomerFi";
    repo = pname;
    rev = version;
    sha256 = "sha256-Qp5iVk71JxhPVrytWuXkzpqPNPmMQubO0t9sgeQfO8c=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    asynctest
    pytest-aiohttp
    pytest-asyncio
    pytest-sugar
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioswitcher" ];

  meta = with lib; {
    description = "Python module to interact with Switcher water heater";
    homepage = "https://github.com/TomerFi/aioswitcher";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
