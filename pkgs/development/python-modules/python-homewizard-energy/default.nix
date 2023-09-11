{ lib
, aiohttp
, aresponses
, awesomeversion
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-homewizard-energy";
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "DCSBL";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+RuUNH95Txs6JeObYqg2CQl7qxF4YLVQvBDfzj5L9Bk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    awesomeversion
    aiohttp
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "homewizard_energy"
  ];

  meta = with lib; {
    description = "Library to communicate with HomeWizard Energy devices";
    homepage = "https://github.com/DCSBL/python-homewizard-energy";
    changelog = "https://github.com/DCSBL/python-homewizard-energy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
