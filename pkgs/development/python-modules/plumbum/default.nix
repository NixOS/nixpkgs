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
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = "plumbum";
    rev = "v${version}";
    sha256 = "sha256-bCCcNFz+ZsbKSF7aCfy47lBHb873tDYN0qFuSCxJp1w=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov-config=setup.cfg" ""
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
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
    description = " Plumbum: Shell Combinators ";
    homepage = " https://github.com/tomerfiliba/plumbum ";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
