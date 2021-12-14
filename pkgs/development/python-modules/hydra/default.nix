{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, pytestCheckHook
, importlib-resources, omegaconf, jre_headless, antlr4-python3-runtime }:

buildPythonPackage rec {
  pname = "hydra";
  version = "1.1.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:1svzysrjg47gb6lxx66fzd8wbhpbbsppprpbqssf5aqvhxgay3qk";
  };

  nativeBuildInputs = [ jre_headless ];
  checkInputs = [ pytestCheckHook ];
  propagatedBuildInputs = [ omegaconf antlr4-python3-runtime ]
    ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  # test environment setup broken under Nix for a few tests:
  disabledTests = [
    "test_bash_completion_with_dot_in_path"
    "test_install_uninstall"
    "test_config_search_path"
  ];
  disabledTestPaths = [ "tests/test_hydra.py" ];

  meta = with lib; {
    description = "A framework for configuring complex applications";
    homepage = "https://hydra.cc";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
