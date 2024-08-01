{
  lib,
  aiohttp,
  aioresponses,
  pydantic,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aioopenexchangerates";
  version = "0.4.14";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aioopenexchangerates";
    rev = "refs/tags/v${version}";
    hash = "sha256-tQPLGtz6lqwa61tpAm+O3+5EM9zJqZEyWh5TPHXBlag=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=aioopenexchangerates --cov-report=term-missing:skip-covered" ""
  '';

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [ poetry-core ];


  dependencies = [
    aiohttp
    pydantic
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioopenexchangerates" ];

  meta = with lib; {
    description = "Library for the Openexchangerates API";
    homepage = "https://github.com/MartinHjelmare/aioopenexchangerates";
    changelog = "https://github.com/MartinHjelmare/aioopenexchangerates/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
