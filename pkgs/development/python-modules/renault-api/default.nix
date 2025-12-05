{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  click,
  cryptography,
  dateparser,
  fetchFromGitHub,
  marshmallow-dataclass,
  poetry-core,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  syrupy,
  tabulate,
  typeguard,
}:

buildPythonPackage rec {
  pname = "renault-api";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "renault-api";
    tag = "v${version}";
    hash = "sha256-FH6x+hknNGgrSHaOt7RTYeuVLqb/DNy7X3065VvcFwA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    cryptography
    marshmallow-dataclass
    pyjwt
  ];

  optional-dependencies = {
    cli = [
      click
      dateparser
      tabulate
    ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
    typeguard
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "renault_api" ];

  meta = with lib; {
    description = "Python library to interact with the Renault API";
    homepage = "https://github.com/hacf-fr/renault-api";
    changelog = "https://github.com/hacf-fr/renault-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "renault-api";
  };
}
