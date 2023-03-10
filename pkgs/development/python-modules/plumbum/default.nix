{ lib
, buildPythonPackage
, fetchFromGitHub
, openssh
, ps
, psutil
, pytest-mock
, pytest-timeout
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "plumbum";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = "plumbum";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-SqZO9qYOtBB+KWP0DLsImI64QTTpYKzWMYwSua9k2S0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"--cov-config=setup.cfg", ' ""
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
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
