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
  loguru,
  nix,
  nix-prefetch-git,
  nonbloat-db,
  nurl,
  platformdirs,
  pydantic,
  typer,

  # tests
  pytestCheckHook,
  aioresponses,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
}:
buildPythonPackage rec {
  pname = "nixpkgs-updaters-library";
  version = "2.1.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "PerchunPak";
    repo = "nixpkgs-updaters-library";
    tag = "v${version}";
    hash = "sha256-V9NGM3GzkI8maBo5dBH1nP7/VPVfSxq+TdVdNTOgBEs=";
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
    loguru
    nonbloat-db
    platformdirs
    pydantic
    typer
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    description = "Boilerplate-less updater library for Nixpkgs ecosystems";
    homepage = "https://github.com/PerchunPak/nixpkgs-updaters-library";
    changelog = "https://github.com/PerchunPak/nixpkgs-updaters-library/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ perchun ];
  };
}
