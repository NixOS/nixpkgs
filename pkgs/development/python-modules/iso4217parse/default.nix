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
    # need unreleased https://github.com/tammoippen/iso4217parse/pull/20
    rev = "4b1e1ae9c4e800b232f5f2a9a866db80be82cd6d";
    hash = "sha256-pFCvJEBnCeUIrYe8ebl+dxSZpYtClSIR7V74vdddmg4=";
  };

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
    changelog = "https://github.com/tammoippen/iso4217parse/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dwoffinden ];
  };
})
