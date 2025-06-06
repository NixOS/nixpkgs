{
  lib,
  antlr4,
  antlr4-python3-runtime,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  importlib-resources,
  jre_headless,
  omegaconf,
  packaging,
  pytestCheckHook,
  pythonOlder,
  substituteAll,
}:

buildPythonPackage rec {
  pname = "hydra-core";
  version = "1.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "hydra";
    rev = "refs/tags/v${version}";
    hash = "sha256-kD4BStnstr5hwyAOxdpPzLAJ9MZqU/CPiHkaD2HnUPI=";
  };

  patches = [
    (substituteAll {
      src = ./antlr4.patch;
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

    sed -i 's/antlr4-python3-runtime==.*/antlr4-python3-runtime/' requirements/requirements.txt
  '';

  nativeBuildInputs = [ jre_headless ];

  propagatedBuildInputs = [
    antlr4-python3-runtime
    omegaconf
    packaging
  ] ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    "-W"
    "ignore::UserWarning"
  ];

  # Test environment setup broken under Nix for a few tests:
  disabledTests = [
    "test_bash_completion_with_dot_in_path"
    "test_install_uninstall"
    "test_config_search_path"
    # does not raise UserWarning
    "test_initialize_compat_version_base"
  ];

  disabledTestPaths = [ "tests/test_hydra.py" ];

  pythonImportsCheck = [
    "hydra"
    # See https://github.com/NixOS/nixpkgs/issues/208843
    "hydra.version"
  ];

  meta = with lib; {
    description = "Framework for configuring complex applications";
    homepage = "https://hydra.cc";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
