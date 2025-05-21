{
  lib,
  stdenv,
  buildPythonPackage,
  build,
  click,
  fetchPypi,
  pep517,
  pip,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  tomli,
  tomli-w,
  wheel,
}:

buildPythonPackage rec {
  pname = "pip-tools";
  version = "7.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hkgm9Qc4ZEUOJNvuuFzjkgzfsJhIo9aev1N7Uh8UvMk=";
  };

  patches = [ ./fix-setup-py-bad-syntax-detection.patch ];

  build-system = [ setuptools-scm ];

  dependencies = [
    build
    click
    pep517
    pip
    setuptools
    wheel
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

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

  disabledTests = [
    # Tests require network access
    "network"
    "test_direct_reference_with_extras"
    "test_local_duplicate_subdependency_combined"
    "test_bad_setup_file"
    # Assertion error
    "test_compile_recursive_extras"
    "test_combine_different_extras_of_the_same_package"
    "test_diff_should_not_uninstall"
    "test_cli_compile_all_extras_with_multiple_packages"
    # Deprecations
    "test_error_in_pyproject_toml"

    # pip 25.0 compat issues
    # https://github.com/jazzband/pip-tools/issues/2112
    # requirement doesn't end with semicolon
    "test_resolver"
    "test_resolver__custom_unsafe_deps"
    # constraints.txt is now in a tmpdir
    "test_preserve_via_requirements_constrained_dependencies_when_run_twice"
    "test_annotate_option"
    # TypeError("'<' not supported between instances of 'InstallationCandidate' and 'InstallationCandidate'")>.exit_code
    "test_no_candidates"
    "test_no_candidates_pre"
    "test_failure_of_legacy_resolver_prompts_for_backtracking"
  ];

  pythonImportsCheck = [ "piptools" ];

  meta = with lib; {
    description = "Keeps your pinned dependencies fresh";
    homepage = "https://github.com/jazzband/pip-tools/";
    changelog = "https://github.com/jazzband/pip-tools/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
