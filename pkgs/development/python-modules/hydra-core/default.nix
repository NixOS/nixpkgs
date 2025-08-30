{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # patches
  replaceVars,
  antlr4,
  fetchpatch,

  # nativeBuildInputs
  jre_headless,

  # dependencies
  antlr4-python3-runtime,
  omegaconf,
  packaging,

  # tests
  pytest8_3CheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "hydra-core";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "hydra";
    tag = "v${version}";
    hash = "sha256-kD4BStnstr5hwyAOxdpPzLAJ9MZqU/CPiHkaD2HnUPI=";
  };

  patches = [
    (replaceVars ./antlr4.patch {
      antlr_jar = "${antlr4.out}/share/java/antlr-${antlr4.version}-complete.jar";
    })
    # https://github.com/facebookresearch/hydra/pull/2731
    (fetchpatch {
      name = "setuptools-67.5.0-test-compatibility.patch";
      url = "https://github.com/facebookresearch/hydra/commit/25873841ed8159ab25a0c652781c75cc4a9d6e08.patch";
      hash = "sha256-oUfHlJP653o3RDtknfb8HaaF4fpebdR/OcbKHzJFK/Q=";
    })
  ];

  postPatch = ''
    # We substitute the path to the jar with the one from our antlr4
    # package, so this file becomes unused
    rm -v build_helpers/bin/antlr*-complete.jar
  '';

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [ jre_headless ];

  pythonRelaxDeps = [
    "antlr4-python3-runtime"
  ];

  dependencies = [
    antlr4-python3-runtime
    omegaconf
    packaging
  ];

  nativeCheckInputs = [ pytest8_3CheckHook ];

  pytestFlags = [
    "-Wignore::UserWarning"
  ];

  # Test environment setup broken under Nix for a few tests:
  disabledTests = [
    "test_bash_completion_with_dot_in_path"
    "test_install_uninstall"
    "test_config_search_path"
    # does not raise UserWarning
    "test_initialize_compat_version_base"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # AssertionError: Regex pattern did not match
    "test_failure"
  ];

  disabledTestPaths = [ "tests/test_hydra.py" ];

  pythonImportsCheck = [
    "hydra"
    # See https://github.com/NixOS/nixpkgs/issues/208843
    "hydra.version"
  ];

  meta = {
    description = "Framework for configuring complex applications";
    homepage = "https://hydra.cc";
    changelog = "https://github.com/facebookresearch/hydra/blob/v${version}/NEWS.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
