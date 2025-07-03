{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  overrides,
  pydantic,
  pyxdg,
  pyyaml,
  requests,
  requests-unixsocket,
  pyfakefs,
  pytestCheckHook,
  pytest-check,
  pytest-mock,
  pytest-subprocess,
  requests-mock,
  hypothesis,
  jsonschema,
  git,
  squashfsTools,
  socat,
  setuptools-scm,
  stdenv,
  ant,
  maven,
  jdk,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "craft-parts";
  version = "2.15.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-parts";
    tag = version;
    hash = "sha256-UW4VdJvEG4w7CM5aj1OKK91nsywQgsguJ+tnhEbqwYA=";
  };

  patches = [ ./bash-path.patch ];

  build-system = [ setuptools-scm ];

  pythonRelaxDeps = [
    "requests"
    "urllib3"
    "pydantic"
  ];

  dependencies = [
    overrides
    pydantic
    pyxdg
    pyyaml
    requests
    requests-unixsocket
  ];

  pythonImportsCheck = [ "craft_parts" ];

  nativeCheckInputs = [
    ant
    git
    hypothesis
    jdk
    jsonschema
    maven
    pyfakefs
    pytest-check
    pytest-mock
    pytest-subprocess
    pytestCheckHook
    requests-mock
    socat
    squashfsTools
    writableTmpDirAsHomeHook
  ];

  pytestFlagsArray = [ "tests/unit" ];

  disabledTests = [
    # Relies upon paths not present in Nix (like /bin/bash)
    "test_run_builtin_build"
    "test_run_prime"
    "test_get_build_packages_with_source_type"
    "test_get_build_packages"
    # Relies upon certain paths being present that don't make sense on Nix.
    "test_java_plugin_jre_not_17"
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
      # Hard-coded assumptions about arguments relating to 'x86_64'
      "tests/unit/plugins/test_dotnet_v2_plugin.py"
    ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Software artifact parts builder from Canonical";
    homepage = "https://github.com/canonical/craft-parts";
    changelog = "https://github.com/canonical/craft-parts/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
