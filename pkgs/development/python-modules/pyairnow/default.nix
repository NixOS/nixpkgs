{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytest-aiohttp
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyairnow";
  version = "1.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "asymworks";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-5i/O+u6BTqx0TajprAhnAa1ao3EzbBeBeKsczW05WRk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyairnow"
  ];

  meta = with lib; {
    description = "Python wrapper for EPA AirNow Air Quality API";
    homepage = "https://github.com/asymworks/pyairnow";
    changelog = "https://github.com/asymworks/pyairnow/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
