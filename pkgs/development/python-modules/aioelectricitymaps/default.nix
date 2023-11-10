{ lib
, aiohttp
, aresponses
, buildPythonPackage
, dataclasses-json
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, syrupy
}:

buildPythonPackage rec {
  pname = "aioelectricitymaps";
  version = "0.1.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jpbede";
    repo = "aioelectricitymaps";
    rev = "refs/tags/v${version}";
    hash = "sha256-XJw3oy5IHyXmdoVxSU15dWHcc4Wd435Lyr/wpz53aZI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    dataclasses-json
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [
    "aioelectricitymaps"
  ];

  meta = with lib; {
    description = "Module for interacting with Electricity maps";
    homepage = "https://github.com/jpbede/aioelectricitymaps";
    changelog = "https://github.com/jpbede/aioelectricitymaps/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
