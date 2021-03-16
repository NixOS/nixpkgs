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
  version = "2.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "1pzdcy65gndrlyhrwyc1rwsh8n4w79wla8n9fr13m00vac3cqkl0";
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
