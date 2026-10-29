{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  build,
  gitMinimal,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  setuptools,
  tomli-w,
  trove-classifiers,
  virtualenv,

  # Disable checks by default, as checks require gitMinimal, which eventually
  # depends on hatchling, which depends on tomlkit, which depends on
  # poetry-core, leading to infinite recursion.
  doCheck ? false,

  # self-reference for tests, since finalAttrs.finalPackage exposes neither
  # `override` nor `overridePythonAttrs`.
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "poetry-core";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = "poetry-core";
    tag = finalAttrs.version;
    hash = "sha256-Io2VpLxnJesO4QohsunD7ogr87NiNjGeTmEl9wFswkw=";
  };

  inherit doCheck;

  nativeCheckInputs = [
    build
    gitMinimal
    pytest-mock
    pytest-cov-stub
    pytestCheckHook
    setuptools
    tomli-w
    trove-classifiers
    virtualenv
  ];

  disabledTests = [
    # Requires git history to work correctly
    "default_with_excluded_data"
    "default_src_with_excluded_data"
    "test_package_with_include"
    # Distribution timestamp mismatches, as we operate on 1980-01-02
    "test_sdist_mtime_zero"
    "test_sdist_members_mtime_default"
    "test_dist_info_date_time_default_value"
  ];

  pythonImportsCheck = [ "poetry.core" ];

  # Allow for packages to use PEP420's native namespace
  pythonNamespaces = [ "poetry" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-int-conversion";

  # In passthru.tests, build with the check phase enabled, since that'll be
  # outside the bootstrap dependency chain.
  passthru.tests.withChecks = poetry-core.override { doCheck = true; };

  meta = {
    changelog = "https://github.com/python-poetry/poetry-core/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Poetry PEP 517 Build Backend";
    homepage = "https://github.com/python-poetry/poetry-core/";
    license = lib.licenses.mit;
    teams = [ lib.teams.python ];
  };
})
