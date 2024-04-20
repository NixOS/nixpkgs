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
  version = "0.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "renault-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-FZ1VNO8gEH7HJRu9EVuKIwSQbceG720tCVqAPqHwISQ=";
  };

  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    cryptography
    marshmallow-dataclass
    pyjwt
  ];

  dependencies = [
    aioresponses
    pytest-asyncio
  ];

  passthru.optional-dependencies = {
    cli = [
      click
      dateparser
      tabulate
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    typeguard
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [ "--asyncio-mode=auto" ];

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
