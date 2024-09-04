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
  pydantic-yaml,
  pyfakefs,
  pygit2,
  pytest-check,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  responses,
  setuptools-scm,
  snap-helpers,
}:

buildPythonPackage rec {
  pname = "craft-application";
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-application";
    rev = "refs/tags/${version}";
    hash = "sha256-2JfCe7FJtuObC/4miA+OC/ctGy1fhdgI7DsowNYjQk8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==70.1.0" "setuptools"
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
    craft-providers
    pydantic-yaml
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
    changelog = "https://github.com/canonical/craft-application/blob/${src.rev}/docs/reference/changelog.rst";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
