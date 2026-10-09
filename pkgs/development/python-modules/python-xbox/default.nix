{
  buildPythonPackage,
  cryptography,
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

buildPythonPackage (finalAttrs: {
  pname = "python-xbox";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tr4nt0r";
    repo = "python-xbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Aw6EdGkKDEb75mAPZm+z4V1Y4sCNGIxbOmSE9tv1YFY=";
  };

  build-system = [
    hatch-regex-commit
    hatchling
  ];

  pythonRelaxDeps = [
    "pydantic"
  ];

  dependencies = [
    cryptography
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
    changelog = "https://github.com/tr4nt0r/python-xbox/releases/tag/${finalAttrs.src.tag}";
    description = "Library to authenticate with Xbox Network and use their API";
    homepage = "https://github.com/tr4nt0r/python-xbox";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
