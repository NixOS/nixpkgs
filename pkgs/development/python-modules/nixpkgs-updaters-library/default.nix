{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  aiohttp,
  frozendict,
  inject,
  joblib,
  loguru,
  nix,
  nix-prefetch-git,
  nurl,
  platformdirs,
  pydantic,
  typer,

  # tests
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  aioresponses,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
}:
buildPythonPackage (finalAttrs: {
  pname = "nixpkgs-updaters-library";
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "PerchunPak";
    repo = "nixpkgs-updaters-library";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y6EVoxu/3aBRce2bQsnlt/faZY17b8Rr4hd7wsTPnjE=";
  };

  postPatch = ''
    substituteInPlace nupd/executables.py \
      --replace-fail '"nurl"' '"${lib.getExe nurl}"' \
      --replace-fail '"nix-prefetch-url"' '"${lib.getExe' nix "nix-prefetch-git"}"' \
      --replace-fail '"nix-prefetch-git"' '"${lib.getExe' nix-prefetch-git "nix-prefetch-git"}"'
  '';

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    frozendict
    inject
    joblib
    loguru
    platformdirs
    pydantic
    typer
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    description = "Boilerplate-less updater library for Nixpkgs ecosystems";
    homepage = "https://github.com/PerchunPak/nixpkgs-updaters-library";
    changelog = "https://github.com/PerchunPak/nixpkgs-updaters-library/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PerchunPak ];
  };
})
