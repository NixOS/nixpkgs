{ lib
, aiohttp
, asynctest
, buildPythonPackage
, fetchFromGitHub
, poetry
, pytest-aiohttp
, pytest-asyncio
, pytest-sugar
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aioswitcher";
  version = "1.2.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "TomerFi";
    repo = pname;
    rev = version;
    sha256 = "0wvca1jbyj4bwrpkpklbxnkvdp9zs7mrvg5b9vkx2hpyr81vyxam";
  };

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [ aiohttp ];

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
