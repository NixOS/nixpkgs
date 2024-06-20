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
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "aioopenexchangerates";
  version = "0.4.12";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aioopenexchangerates";
    rev = "refs/tags/v${version}";
    hash = "sha256-A9d7nAqVwiIsS6f+A4PCGbONdhZb55JSmNuAFG990Ek=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=aioopenexchangerates --cov-report=term-missing:skip-covered" ""
  '';

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

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
