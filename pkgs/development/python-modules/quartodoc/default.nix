{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  syrupy,
  click,
  griffe,
  importlib-metadata,
  importlib-resources,
  plum-dispatch,
  pydantic,
  pyyaml,
  sphobjinv,
  tabulate,
  typing-extensions,
  watchdog,
  pythonOlder,
  pytestCheckHook,
  fetchpatch2,
}:

buildPythonPackage rec {
  pname = "quartodoc";
  version = "0.7.2";
  pyproject = true;

  # requires when plum-dispatch > 2.00
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "machow";
    repo = "quartodoc";
    rev = "refs/tags/v${version}";
    hash = "sha256-Cmn/eMnirdCT2zRgjzt/t5Cm9BWrbUjKavCj+auMY3w=";
  };

  patches = [
    # fix: compatibility with griffe 0.39
    # remove after next release
    # see https://github.com/machow/quartodoc/commit/7b44cd229cabe90d34acf275e45e08054d0aea67
    (fetchpatch2 {
      name = "fix-griffe-0_39.patch";
      url = "https://github.com/machow/quartodoc/commit/7b44cd229cabe90d34acf275e45e08054d0aea67.patch";
      hash = "sha256-pxySsGVe9NQZOGX6S2qLZT7QAWkscEfkSMkXfFT6Ygo=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    click
    griffe
    importlib-metadata
    importlib-resources
    plum-dispatch
    pydantic
    pyyaml
    sphobjinv
    tabulate
    typing-extensions
    watchdog
  ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # failed when griffe >= 0.45.2
    # see https://github.com/machow/quartodoc/issues/343
    "test_func_resolve_alias"
    "test_preview_warn_alias_no_load"
  ];

  pythonImportsCheck = [ "quartodoc" ];

  meta = {
    description = "Generate API documentation with quarto";
    homepage = "https://github.com/machow/quartodoc";
    license = lib.licenses.mit;
    mainProgram = "quartodoc";
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
