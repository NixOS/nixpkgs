{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  poetry-core,
  fetchpatch,
  pytest-cov-stub,
  pytestCheckHook,
  iso3166,
}:

buildPythonPackage (finalAttrs: {
  pname = "iso4217parse";
  version = "0.6.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tammoippen";
    repo = "iso4217parse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DPuauUTgBlw82W7AvoVNuqiE4ToXy8EmHZM40YXR+CA=";
  };

  patches = [
    # Switch to poetry-core, https://github.com/tammoippen/iso4217parse/pull/20
    ./use-poetry-core.patch
  ];

  build-system = [
    poetry-core
  ];

  pythonImportsCheck = [
    "iso4217parse"
  ];
  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    iso3166
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Parse currencies (symbols and codes) from and to ISO4217";
    homepage = "https://github.com/tammoippen/iso4217parse";
    changelog = "https://github.com/tammoippen/iso4217parse/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dwoffinden ];
  };
})
