{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiopegelonline";
  version = "0.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "aiopegelonline";
    rev = "refs/tags/v${version}";
    hash = "sha256-r+5b52N/vliKHx6qOLJ4lWcQt1TPEcn5Dz7cZNhRbNg=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiopegelonline"
  ];

  meta = with lib; {
    description = "Library to retrieve data from PEGELONLINE";
    homepage = "https://github.com/mib1185/aiopegelonline";
    changelog = "https://github.com/mib1185/aiopegelonline/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
