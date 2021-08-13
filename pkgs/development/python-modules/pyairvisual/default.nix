{ lib
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, fetchFromGitHub
, numpy
, poetry-core
, pysmb
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyairvisual";
  version = "5.0.9";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "1jfbwnipklpgxjgsgsx4j53anbqyrbgvj0wb84fvsm32jq9m8avf";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    numpy
    pysmb
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [ "examples/" ];

  pythonImportsCheck = [ "pyairvisual" ];

  meta = with lib; {
    description = "Python library for interacting with AirVisual";
    homepage = "https://github.com/bachya/pyairvisual";
    changelog = "https://github.com/bachya/pyairvisual/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
