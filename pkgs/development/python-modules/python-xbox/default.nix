{
  buildPythonPackage,
  ecdsa,
  fetchFromGitHub,
  freezegun,
  hatch-regex-commit,
  hatchling,
  httpx,
  lib,
  ms-cv,
  platformdirs,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  respx,
}:

buildPythonPackage rec {
  pname = "python-xbox";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tr4nt0r";
    repo = "python-xbox";
    tag = "v${version}";
    hash = "sha256-YP8iK7uGycwKlWwAUmfk3qXI+c6cddg9nQ4NMQF7wDQ=";
  };

  build-system = [
    hatch-regex-commit
    hatchling
  ];

  pythonRelaxDeps = [
    "pydantic"
  ];

  dependencies = [
    ecdsa
    httpx
    ms-cv
    pydantic
  ];

  optional-dependencies = {
    cli = [
      platformdirs
    ];
  };

  pythonImportsCheck = [ "pythonxbox" ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  meta = {
    changelog = "https://github.com/tr4nt0r/python-xbox/releases/tag/${src.tag}";
    description = ":ibrary to authenticate with Xbox Network and use their API";
    homepage = "https://github.com/tr4nt0r/python-xbox";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
