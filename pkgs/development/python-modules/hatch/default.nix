{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  uv,

  # build-system,
  hatch-vcs,
  hatchling,

  # dependencies
  click,
  httpx,
  hyperlink,
  keyring,
  packaging,
  pexpect,
  platformdirs,
  pyproject-hooks,
  python-discovery,
  rich,
  shellingham,
  tomli-w,
  tomlkit,
  userpath,
  virtualenv,
  # python<3.14 only
  pythonOlder,
  backports-zstd,

  # tests
  binary,
  cargo,
  flit-core,
  gitMinimal,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  setuptools,
  versionCheckHook,
  writableTmpDirAsHomeHook,

  darwin,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "hatch";
  version = "1.16.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "hatch";
    tag = "hatch-v${finalAttrs.version}";
    hash = "sha256-pUlRy8ar0zXsGGSA1VTZyPiU4LruYp/maU2C5T4E5WI=";
  };

  patches = [
    (replaceVars ./inject-uv-path.patch {
      uv = lib.getExe uv;
    })
  ];

  build-system = [
    hatchling
    hatch-vcs
  ];

  pythonRemoveDeps = [
    "uv"
  ];
  pythonRelaxDeps = [
    "virtualenv"
  ];
  dependencies = [
    click
    hatchling
    httpx
    hyperlink
    keyring
    packaging
    pexpect
    platformdirs
    pyproject-hooks
    python-discovery
    rich
    shellingham
    tomli-w
    tomlkit
    userpath
    virtualenv
  ]
  ++ lib.optionals (pythonOlder "3.14") [
    backports-zstd
  ];

  nativeCheckInputs = [
    binary
    flit-core
    pytest-mock
    pytest-xdist
    pytestCheckHook
    setuptools
    cargo
    gitMinimal
    versionCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.ps
  ];

  disabledTests = [
    # AssertionError: assert ['dep2', 'pro...u7kv', 'dep1'] == ['dep2', 'pro...u7kv', 'dep1']
    # At index 1 diff: 'proj@ file:///build/tmp5snbu7kv' != 'proj @ file:///build/tmp5snbu7kv'
    "test_all"
    "test_context_formatting"
    "test_dependencies"
    "test_project_dependencies_context_formatting"

    # AssertionError: assert (1980, 1, 2, 0, 0, 0) == (2020, 2, 2, 0, 0, 0)
    "test_default"
    "test_editable_default"
    "test_editable_default_extra_dependencies"
    "test_editable_default_force_include"
    "test_editable_default_force_include_option"
    "test_editable_default_symlink"
    "test_editable_exact"
    "test_editable_exact_extra_dependencies"
    "test_editable_exact_force_include"
    "test_editable_exact_force_include_build_data_precedence"
    "test_editable_exact_force_include_option"
    "test_editable_pth"
    "test_explicit_path"

    # Loosen hatchling runtime version dependency
    "test_core"
    # New failing
    "test_guess_variant"
    "test_open"
    "test_no_open"
    "test_uv_env"
    "test_pyenv"
    "test_pypirc"
    # Relies on FHS
    # Could not read ELF interpreter from any of the following paths: /bin/sh, /usr/bin/env, /bin/dash, /bin/ls
    "test_new_selected_python"

    # https://github.com/pypa/hatch/issues/2006
    "test_project_location_basic_set_first_project"
    "test_project_location_complex_set_first_project"

    # TypeError: 'int' object is not subscriptable with newer packaging
    "test_begin"
    "test_continue"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # This test assumes it is running on macOS with a system shell on the PATH.
    # It is not possible to run it in a nix build using a /nix/store shell.
    # See https://github.com/pypa/hatch/pull/709 for the relevant code.
    "test_populate_default_popen_kwargs_executable"

    # Those tests fail because the final wheel is named '...2-macosx_11_0_arm64.whl' instead of
    # '...2-macosx_14_0_arm64.whl'
    "test_macos_archflags"
    "test_macos_max_compat"

    # https://github.com/pypa/hatch/issues/1942
    "test_features"
    "test_sync_dynamic_dependencies"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "test_resolve" ];

  disabledTestPaths = [
    # httpx.ConnectError: [Errno -3] Temporary failure in name resolution
    "tests/workspaces/test_config.py"

    # additional comment `-*- coding: utf-8 -*-` in output
    "tests/backend/builders/test_sdist.py"

    # missing output `Syncing dependencies`
    "tests/cli/build/test_build.py"
    "tests/cli/project/test_metadata.py"
    "tests/cli/version/test_version.py"

    # AttributeError: 'WheelBuilderConfig' object has no attribute 'sbom_files'
    "tests/backend/builders/test_wheel.py::TestSBOMFiles"

    # some issue with the version of `binary`
    "tests/dep/test_sync.py::test_dependency_not_found"
    "tests/dep/test_sync.py::test_marker_unmet"

    # AssertionError on the version metadata
    # https://github.com/pypa/hatch/issues/1877
    "tests/backend/metadata/test_spec.py::TestCoreMetadataV21::test_all"
    "tests/backend/metadata/test_spec.py::TestCoreMetadataV21::test_license_expression"
    "tests/backend/metadata/test_spec.py::TestCoreMetadataV22::test_all"
    "tests/backend/metadata/test_spec.py::TestCoreMetadataV22::test_license_expression"
    "tests/backend/metadata/test_spec.py::TestCoreMetadataV23::test_all"
    "tests/backend/metadata/test_spec.py::TestCoreMetadataV23::test_license_expression"
    "tests/backend/metadata/test_spec.py::TestCoreMetadataV23::test_license_files"
    "tests/backend/metadata/test_spec.py::TestProjectMetadataFromCoreMetadata::test_license_files"

    # Table title centering changed in newer Rich
    "tests/cli/dep/show/test_table.py"
    "tests/cli/env/test_show.py"
    "tests/cli/python/test_show.py"

    # Version scheme failures with newer packaging
    "tests/backend/version/scheme/test_standard.py::TestWithEpoch::test_correct[minor,dev-1!0.1.0.dev0]"
    "tests/backend/version/scheme/test_standard.py::TestMultiple::test_correct[minor,dev-0.1.0.dev0]"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert [call('test h...2p32/bin/sh')] == [call('test h..., shell=True)]
    # At index 0 diff:
    #    call('test hatch-test.py3.10', shell=True, executable='/nix/store/b34ianga4diikh0kymkpqwmvba0mmzf7-bash-5.2p32/bin/sh')
    # != call('test hatch-test.py3.10', shell=True)
    "tests/cli/fmt/test_fmt.py"
    "tests/cli/test/test_test.py"

    # Dependency/versioning errors in the CLI tests, only seem to show up on Darwin
    # https://github.com/pypa/hatch/issues/1893
    "tests/cli/env/test_create.py::test_sync_dependencies_pip"
    "tests/cli/env/test_create.py::test_sync_dependencies_uv"
    "tests/cli/project/test_metadata.py::TestBuildDependenciesMissing::test_no_compatibility_check_if_exists"
    "tests/cli/run/test_run.py::TestScriptRunner::test_dependencies"
    "tests/cli/run/test_run.py::TestScriptRunner::test_dependencies_from_tool_config"
    "tests/cli/run/test_run.py::test_dependency_hash_checking"
    "tests/cli/run/test_run.py::test_sync_dependencies"
    "tests/cli/run/test_run.py::test_sync_project_dependencies"
    "tests/cli/run/test_run.py::test_sync_project_features"
    "tests/cli/version/test_version.py::test_no_compatibility_check_if_exists"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "hatch-v([0-9.]+)"
      ];
    };
  };

  meta = {
    description = "Modern, extensible Python project manager";
    homepage = "https://hatch.pypa.io/latest/";
    changelog = "https://github.com/pypa/hatch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "hatch";
  };
})
