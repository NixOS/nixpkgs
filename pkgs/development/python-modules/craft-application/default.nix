{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  git,
  craft-archives,
  craft-cli,
  craft-grammar,
  craft-parts,
  craft-providers,
  pydantic-yaml-0,
  pyyaml,
  setuptools,
  setuptools-scm,
  snap-helpers,
  stdenv,
  pygit2,
  pyfakefs,
  pytestCheckHook,
  pytest-check,
  pytest-mock,
  responses,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "craft-application";
  version = "2.5.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-application";
    rev = "refs/tags/${version}";
    hash = "sha256-66Ldo88DJ6v0+ekvDl++eDzhdn95yxq0SMdzQxTGl5k=";
  };

  postPatch = ''
    substituteInPlace craft_application/__init__.py \
      --replace-fail "dev" "${version}"

    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==69.4.0" "setuptools"
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [ "craft_application" ];

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

  pytestFlagsArray = [ "tests/unit" ];

  disabledTests = [
    "test_to_yaml_file"
    # Tests expecting pytest-time
    "test_monitor_builds_success"
  ] ++ lib.optionals stdenv.isAarch64 [
    # These tests have hardcoded "amd64" strings which fail on aarch64
    "test_process_grammar_build_for"
    "test_process_grammar_platform"
    "test_process_grammar_default"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The basis for Canonical craft applications";
    homepage = "https://github.com/canonical/craft-application";
    changelog = "https://github.com/canonical/craft-application/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
