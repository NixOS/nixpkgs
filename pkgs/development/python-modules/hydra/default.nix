{ stdenv
, lib
, antlr4_9-python3-runtime
, buildPythonPackage
, fetchFromGitHub
, importlib-resources
, jre_headless
, omegaconf
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hydra";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4r0ZWW9SGl35Oupf0ejwL/s6Nas6RoSN2egiBrvFZIA=";
  };

  nativeBuildInputs = [
    jre_headless
  ];

  propagatedBuildInputs = [
    antlr4_9-python3-runtime
    omegaconf
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # Test environment setup broken under Nix for a few tests:
  disabledTests = [
    "test_bash_completion_with_dot_in_path"
    "test_install_uninstall"
    "test_config_search_path"
  ];

  disabledTestPaths = [
    "tests/test_hydra.py"
  ];

  pythonImportsCheck = [
    "hydra"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "A framework for configuring complex applications";
    homepage = "https://hydra.cc";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
