{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  rich,
  typer,
  uv-build,
}:
buildPythonPackage (finalAttrs: {
  pname = "oinker";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "major";
    repo = "oinker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jDQKTllteOL30mY089URl/36hY3f5KzSFPNubqnd0d8=";
  };

  build-system = [ uv-build ];

  dependencies = [ httpx ];

  optional-dependencies = {
    cli = [
      rich
      typer
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ finalAttrs.finalPackage.optional-dependencies.cli;

  pythonImportsCheck = [ "oinker" ];

  meta = {
    description = "Pythonic client library for Porkbun DNS";
    mainProgram = "oinker";
    homepage = "https://major.github.io/oinker";
    changelog = "https://github.com/major/oinker/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.all;
  };
})
