{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  build,
  git,
  pytest-mock,
  pytestCheckHook,
  setuptools,
  tomli-w,
  trove-classifiers,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "poetry-core";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = "poetry-core";
    tag = version;
    hash = "sha256-3dmvFn2rxtR0SK8oiEHIVJhpJpX4Mm/6kZnIYNSDv90=";
  };

  nativeCheckInputs = [
    build
    git
    pytest-mock
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
    # Nix changes timestamp
    "test_dist_info_date_time_default_value"
    "test_sdist_members_mtime_default"
    "test_sdist_mtime_zero"
  ];

  pythonImportsCheck = [ "poetry.core" ];

  # Allow for package to use pep420's native namespaces
  pythonNamespaces = [ "poetry" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-int-conversion";

  meta = with lib; {
    changelog = "https://github.com/python-poetry/poetry-core/blob/${src.rev}/CHANGELOG.md";
    description = "Core utilities for Poetry";
    homepage = "https://github.com/python-poetry/poetry-core/";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
