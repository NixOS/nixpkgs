{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  openssh,
  ps,
  psutil,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "plumbum";
  version = "1.8.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = "plumbum";
    rev = "refs/tags/v${version}";
    hash = "sha256-k2H/FBQAWrCN1P587s/OhiCGNasMKEFJYIBIU808rlE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"--cov-config=setup.cfg", ' ""
  '';

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    openssh
    ps
    psutil
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ];

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
    changelog = "https://github.com/tomerfiliba/plumbum/releases/tag/v${version}";
    description = " Plumbum: Shell Combinators ";
    homepage = " https://github.com/tomerfiliba/plumbum ";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
