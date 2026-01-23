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
}:

buildPythonPackage rec {
  pname = "poetry-core";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = "poetry-core";
    tag = version;
    hash = "sha256-l5WTjKa+A66QfWLmrjCQq7ZrSaeuylGIRZr8jsiYq+A=";
  };

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

  meta = {
    changelog = "https://github.com/python-poetry/poetry-core/blob/${src.tag}/CHANGELOG.md";
    description = "Poetry PEP 517 Build Backend";
    homepage = "https://github.com/python-poetry/poetry-core/";
    license = lib.licenses.mit;
    teams = [ lib.teams.python ];
  };
}
