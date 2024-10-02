{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  overrides,
  pydantic_1,
  pydantic-yaml,
  pyxdg,
  pyyaml,
  requests,
  requests-unixsocket,
  urllib3,
  pytestCheckHook,
  pytest-check,
  pytest-mock,
  pytest-subprocess,
  requests-mock,
  hypothesis,
  git,
  squashfsTools,
  setuptools-scm,
  stdenv,
}:

buildPythonPackage rec {
  pname = "craft-parts";
  version = "1.33.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-parts";
    rev = "refs/tags/${version}";
    hash = "sha256-SP2mkaXsU0btnA3aanSA18GkdW6ReLgImOWdpnwZiyU=";
  };

  patches = [ ./bash-path.patch ];

  build-system = [ setuptools-scm ];

  pythonRelaxDeps = [
    "requests"
    "urllib3"
  ];

  dependencies = [
    overrides
    pydantic_1
    pydantic-yaml
    pyxdg
    pyyaml
    requests
    requests-unixsocket
    urllib3
  ];

  pythonImportsCheck = [ "craft_parts" ];

  nativeCheckInputs = [
    git
    hypothesis
    pytest-check
    pytest-mock
    pytest-subprocess
    pytestCheckHook
    requests-mock
    squashfsTools
  ];

  pytestFlagsArray = [ "tests/unit" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Relies upon paths not present in Nix (like /bin/bash)
    "test_run_builtin_build"
    "test_run_prime"
    "test_get_build_packages_with_source_type"
    "test_get_build_packages"
  ];

  disabledTestPaths =
    [
      # Relies upon filesystem extended attributes, and suid/guid bits
      "tests/unit/sources/test_base.py"
      "tests/unit/packages/test_base.py"
      "tests/unit/state_manager"
      "tests/unit/test_xattrs.py"
      "tests/unit/packages/test_normalize.py"
      # Relies upon presence of apt/dpkg.
      "tests/unit/packages/test_apt_cache.py"
      "tests/unit/packages/test_deb.py"
      "tests/unit/packages/test_chisel.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      # These tests have hardcoded "amd64" strings which fail on aarch64
      "tests/unit/executor/test_environment.py"
      "tests/unit/features/overlay/test_executor_environment.py"
    ];

  passthru.updateScript = nix-update-script { };

  meta = {
    broken = lib.versionAtLeast pydantic-yaml.version "1";
    description = "Software artifact parts builder from Canonical";
    homepage = "https://github.com/canonical/craft-parts";
    changelog = "https://github.com/canonical/craft-parts/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
