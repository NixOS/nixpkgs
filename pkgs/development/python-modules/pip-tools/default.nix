{
  lib,
  stdenv,
  buildPythonPackage,
  build,
  click,
  fetchFromGitHub,
  pip,
  pyproject-hooks,
  pytest-xdist,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  tomli-w,
  wheel,
}:

buildPythonPackage rec {
  pname = "pip-tools";
  version = "7.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "pip-tools";
    tag = "v${version}";
    hash = "sha256-+y4oXiLWGFIzIT75EZFpcYCX5HKeEyPsk+phTOyoKl8=";
  };

  patches = [
    ./fix-setup-py-bad-syntax-detection.patch
  ];

  build-system = [ setuptools-scm ];

  dependencies = [
    build
    click
    pip
    pyproject-hooks
    setuptools
    wheel
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    tomli-w
  ];

  preCheck = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    # https://github.com/python/cpython/issues/74570#issuecomment-1093748531
    export no_proxy='*';
  '';

  disabledTestPaths = [
    # Most tests require network access
    "tests/test_cli_compile.py"
  ];

  disabledTests = [
    # Tests require network access
    "network"
    "test_direct_reference_with_extras"
    "test_local_duplicate_subdependency_combined"
    "test_bad_setup_file"
    "test_get_hashes_local_repository_cache_miss"
    "test_toggle_reuse_hashes_local_repository"
    "test_get_hashes_from_mixed"
    "test_toggle_reuse_hashes_local_repository"
    "test_generate_hashes_all_platforms"
    "test_iter_dependencies_after_combine_install_requirements"
    "test_iter_dependencies_after_combine_install_requirements_extras"
    "test_name_collision"
    # Assertion error
    "test_compile_recursive_extras"
    "test_compile_build_targets_setuptools_no_wheel_dep"
    "test_combine_different_extras_of_the_same_package"
    "test_diff_should_not_uninstall"
    "test_cli_compile_all_extras_with_multiple_packages"
    # Deprecations
    "test_error_in_pyproject_toml"

    # constraints.txt is now in a tmpdir
    "test_preserve_via_requirements_constrained_dependencies_when_run_twice"
    "test_annotate_option"
    # TypeError("'<' not supported between instances of 'InstallationCandidate' and 'InstallationCandidate'")>.exit_code
    "test_no_candidates"
    "test_no_candidates_pre"
    "test_failure_of_legacy_resolver_prompts_for_backtracking"
  ];

  pythonImportsCheck = [ "piptools" ];

  meta = {
    description = "Keeps your pinned dependencies fresh";
    homepage = "https://github.com/jazzband/pip-tools/";
    changelog = "https://github.com/jazzband/pip-tools/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
