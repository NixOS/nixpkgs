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
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyopenuv";
  version = "2.0.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-QVgNwu/NXSV9nbRN0POBCdKCv6xdp4uSEzFAiHkhVaQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [
    aresponses
    asynctest
    pytest-asyncio
    pytest-aiohttp
    pytest-cov
    pytestCheckHook
  ];

  # Ignore the examples as they are prefixed with test_
  pytestFlagsArray = [ "--ignore examples/" ];
  pythonImportsCheck = [ "pyopenuv" ];

  meta = with lib; {
    description = "Python API to retrieve data from openuv.io";
    homepage = "https://github.com/bachya/pyopenuv";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
