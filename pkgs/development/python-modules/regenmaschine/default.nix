{ lib
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytest-cov
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "regenmaschine";
  version = "3.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "0m6i7vspp8ssdk2k32kznql1j8gkp300kzb7pk67hzvpijdy3mca";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [
    aresponses
    asynctest
    pytest-aiohttp
    pytest-asyncio
    pytest-cov
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "regenmaschine" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python library for interacting with RainMachine smart sprinkler controllers";
    homepage = "https://github.com/bachya/regenmaschine";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
