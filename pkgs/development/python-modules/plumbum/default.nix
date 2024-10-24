{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  paramiko,
  psutil,
  pytest-cov-stub,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "plumbum";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = "plumbum";
    rev = "refs/tags/v${version}";
    hash = "sha256-3PAvSjZ0+BMq+/g4qNNZl27KnAm01fWFYxBBY+feNTU=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  optional-dependencies = {
    ssh = [ paramiko ];
  };

  nativeCheckInputs = [
    psutil
    pytest-cov-stub
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = ''
    export HOME=$TMP
  '';

  disabledTests = [
    # broken in nix env
    "test_change_env"
    "test_dictlike"
    "test_local"
    # incompatible with pytest 7
    "test_incorrect_login"
  ];

  disabledTestPaths = [
    # incompatible with pytest7
    # https://github.com/tomerfiliba/plumbum/issues/594
    "tests/test_remote.py"
  ];

  meta = with lib; {
    description = "Module Shell Combinators";
    changelog = "https://github.com/tomerfiliba/plumbum/releases/tag/v${version}";
    homepage = " https://github.com/tomerfiliba/plumbum";
    license = licenses.mit;
    maintainers = [ ];
  };
}
