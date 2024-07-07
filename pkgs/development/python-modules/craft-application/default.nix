{
  lib,
  stdenv,
  buildPythonPackage,
  craft-archives,
  craft-cli,
  craft-grammar,
  craft-parts,
  craft-providers,
  fetchFromGitHub,
  git,
  hypothesis,
  nix-update-script,
  pydantic-yaml-0,
  pyfakefs,
  pygit2,
  pytest-check,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  responses,
  setuptools-scm,
  setuptools,
  snap-helpers,
}:

buildPythonPackage rec {
  pname = "craft-application";
  version = "2.6.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-application";
    rev = "refs/tags/${version}";
    hash = "sha256-ZhZoR8O5oxcF8+zzihiIbiC/j3AkDL7AjaJSlZ0N48s=";
  };

  postPatch = ''
    substituteInPlace craft_application/__init__.py \
      --replace-fail "dev" "${version}"

    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==69.4.0" "setuptools"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    craft-archives
    craft-cli
    craft-grammar
    craft-parts
    craft-providers
    pydantic-yaml-0
    pygit2
    pyyaml
    snap-helpers
  ];

  nativeCheckInputs = [
    git
    hypothesis
    pyfakefs
    pytest-check
    pytest-mock
    pytestCheckHook
    responses
  ];

  preCheck = ''
    export HOME=$(mktemp -d)

    # Tests require access to /etc/os-release, which isn't accessible in
    # the test environment, so create a fake file, and modify the code
    # to look for it.
    echo 'ID=nixos' > $HOME/os-release
    echo 'NAME=NixOS' >> $HOME/os-release
    echo 'VERSION_ID="24.05"' >> $HOME/os-release

    substituteInPlace craft_application/util/platforms.py \
      --replace-fail "os_utils.OsRelease()" "os_utils.OsRelease(os_release_file='$HOME/os-release')"
  '';

  pythonImportsCheck = [ "craft_application" ];

  pytestFlagsArray = [ "tests/unit" ];

  disabledTests =
    [
      "test_to_yaml_file"
      # Tests expecting pytest-time
      "test_monitor_builds_success"
    ]
    ++ lib.optionals stdenv.isAarch64 [
      # These tests have hardcoded "amd64" strings which fail on aarch64
      "test_process_grammar_build_for"
      "test_process_grammar_platform"
      "test_process_grammar_default"
    ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Basis for Canonical craft applications";
    homepage = "https://github.com/canonical/craft-application";
    changelog = "https://github.com/canonical/craft-application/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
