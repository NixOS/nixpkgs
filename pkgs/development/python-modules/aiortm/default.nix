{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  ciso8601,
  click,
  fetchFromGitHub,
  mashumaro,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiortm";
  version = "0.8.29";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aiortm";
    rev = "refs/tags/v${version}";
    hash = "sha256-mhtU+M4kjKdvmNFr0+HoZjDj1Hf2qYk3nPOWtdPRP/0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=aiortm --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    ciso8601
    click
    mashumaro
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiortm" ];

  meta = with lib; {
    description = "Library for the Remember the Milk API";
    homepage = "https://github.com/MartinHjelmare/aiortm";
    changelog = "https://github.com/MartinHjelmare/aiortm/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "aiortm";
  };
}
