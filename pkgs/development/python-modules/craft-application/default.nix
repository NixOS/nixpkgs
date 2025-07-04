{
  lib,
  stdenv,
  buildPythonPackage,
  craft-archives,
  craft-cli,
  craft-grammar,
  craft-parts,
  craft-platforms,
  craft-providers,
  jinja2,
  fetchFromGitHub,
  gitMinimal,
  hypothesis,
  license-expression,
  nix-update-script,
  pyfakefs,
  pygit2,
  pytest-check,
  pytest-mock,
  pytest-subprocess,
  pytestCheckHook,
  pyyaml,
  responses,
  setuptools-scm,
  snap-helpers,
  freezegun,
  cacert,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "craft-application";
  version = "5.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-application";
    tag = version;
    hash = "sha256-xWGcKJY5ov6SN8CCRK33rVDsDcvKtEnv7Zy9VBLJYYc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==75.8.0" "setuptools"

      substituteInPlace craft_application/git/_utils.py \
        --replace-fail "/snap/core22/current/etc/ssl/certs" "${cacert}/etc/ssl/certs"
  '';

  build-system = [ setuptools-scm ];

  pythonRelaxDeps = [
    "pygit2"
    "requests"
  ];

  dependencies = [
    craft-archives
    craft-cli
    craft-grammar
    craft-parts
    craft-platforms
    craft-providers
    jinja2
    license-expression
    pygit2
    pyyaml
    snap-helpers
  ];

  nativeCheckInputs = [
    freezegun
    gitMinimal
    hypothesis
    pyfakefs
    pytest-check
    pytest-mock
    pytest-subprocess
    pytestCheckHook
    responses
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    # Tests require access to /etc/os-release, which isn't accessible in
    # the test environment, so create a fake file, and modify the code
    # to look for it.
    echo 'ID=nixos' > $HOME/os-release
    echo 'NAME=NixOS' >> $HOME/os-release
    echo 'VERSION_ID="24.05"' >> $HOME/os-release

    substituteInPlace craft_application/util/platforms.py \
      --replace-fail "os_utils.OsRelease()" "os_utils.OsRelease(os_release_file='$HOME/os-release')"

    # Not using `--replace-fail` here only because it simplifies overriding this package in the charmcraft
    # derivation. Once charmcraft has moved to craft-application >= 5, `--replace-fail` can be added.
    substituteInPlace tests/conftest.py \
      --replace "include_lsb=False, include_uname=False, include_oslevel=False" "include_lsb=False, include_uname=False, include_oslevel=False, os_release_file='$HOME/os-release'"
  '';

  pythonImportsCheck = [ "craft_application" ];

  pytestFlagsArray = [ "tests/unit" ];

  disabledTests =
    [
      "test_to_yaml_file"
      # Tests expecting pytest-time
      "test_monitor_builds_success"
      # Temporary fix until new release to support Python 3.13
      "test_grammar_aware_part_error"
      "test_grammar_aware_part_error[part2]"
      "test_grammar_aware_project_error[project0]"
      # Temp fix - asserts fail against error messages which have changed
      # slightly in a later revision of craft-platforms. No functional error.
      "test_platform_invalid_arch"
      "test_platform_invalid_build_arch"
      # Asserts against string output which fails when not on Ubuntu.
      "test_run_error_with_docs_url"
      # Asserts a fallback path for SSL certs that we override in a patch.
      "test_import_fallback_wrong_metadata"
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      # These tests have hardcoded "amd64" strings which fail on aarch64
      "test_process_grammar_build_for"
      "test_process_grammar_platform"
      "test_process_grammar_default"
      "test_create_craft_manifest"
      "test_create_project_manifest"
      "test_from_packed_artifact"
      "test_teardown_session_create_manifest"
    ];

  disabledTestPaths =
    [
      # These tests assert outputs of commands that assume Ubuntu-related output.
      "tests/unit/services/test_lifecycle.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      # Hard-coded assumptions around use of "amd64" arch strings.
      "tests/unit/services/test_project.py"
    ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Basis for Canonical craft applications";
    homepage = "https://github.com/canonical/craft-application";
    changelog = "https://github.com/canonical/craft-application/blob/${src.tag}/docs/reference/changelog.rst";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
