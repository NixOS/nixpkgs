{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  sphinx,
  stdenv,
  unstableGitUpdater,
}:

buildPythonPackage rec {
  pname = "curio";
  version = "1.6-unstable-2024-04-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dabeaz";
    repo = "curio";
    rev = "148454621f9bd8dd843f591e87715415431f6979";
    hash = "sha256-WLu7XF5wiVzBRQH1KRdAbhluTvGE7VvnRQUS0c3SUDk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    sphinx
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests =
    [
      "test_cpu" # timing sensitive
      "test_aside_basic" # times out
      "test_write_timeout" # flaky, does not always time out
      "test_aside_cancel" # fails because modifies PYTHONPATH and cant find pytest
      "test_ssl_outgoing" # touches network
      "test_unix_echo" # socket bind error on hydra when built with other packages
      "test_unix_ssl_server" # socket bind error on hydra when built with other packages
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # connects to python.org:1, expects an OsError, hangs in the darwin sandbox
      "test_create_bad_connection"
    ];

  pythonImportsCheck = [ "curio" ];

  # curio does not package new releaseas any more
  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Library for performing concurrent I/O with coroutines in Python";
    homepage = "https://github.com/dabeaz/curio";
    changelog = "https://github.com/dabeaz/curio/raw/${version}/CHANGES";
    license = licenses.bsd3;
    maintainers = [ maintainers.pbsds ];
  };
}
