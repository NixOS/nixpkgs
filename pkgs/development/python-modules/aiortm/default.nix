{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  ciso8601,
  fetchFromGitHub,
  mashumaro,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typer,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiortm";
  version = "0.10.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aiortm";
    tag = "v${version}";
    hash = "sha256-YclrU24eyk88eOc/nlgeWJ/Fo9SveCzRqQCKYAA9Y9s=";
  };

  pythonRelaxDeps = [ "typer" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    ciso8601
    mashumaro
    yarl
  ];

  optional-dependencies = {
    cli = [ typer ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "aiortm" ];

  meta = with lib; {
    description = "Library for the Remember the Milk API";
    homepage = "https://github.com/MartinHjelmare/aiortm";
    changelog = "https://github.com/MartinHjelmare/aiortm/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "aiortm";
  };
}
