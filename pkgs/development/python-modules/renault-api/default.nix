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
  pythonOlder,
  pytest-asyncio,
  pytestCheckHook,
  tabulate,
  typeguard,
}:

buildPythonPackage rec {
  pname = "renault-api";
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "renault-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-+QqiD4mMfzlHmSiriaS0JzbMdOGCG7cg/xv6zJaPSOU=";
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
    typeguard
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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
