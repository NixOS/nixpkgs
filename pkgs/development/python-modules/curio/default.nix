{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytestCheckHook
, sphinx
, stdenv
}:

buildPythonPackage rec {
  pname = "curio";
  version = "1.6";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VipYbbICFrp9K+gmPeuesHnlYEj5uJBtEdX0WqgcUkc=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    sphinx
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    "test_aside_basic" # times out
    "test_write_timeout" # flaky, does not always time out
    "test_aside_cancel" # fails because modifies PYTHONPATH and cant find pytest
    "test_ssl_outgoing" # touches network
    "test_unix_echo" # socket bind error on hydra when built with other packages
    "test_unix_ssl_server" # socket bind error on hydra when built with other packages
  ] ++ lib.optionals stdenv.isDarwin [
    # connects to python.org:1, expects an OsError, hangs in the darwin sandbox
    "test_create_bad_connection"
  ];

  pythonImportsCheck = [ "curio" ];

  meta = with lib; {
    description = "Library for performing concurrent I/O with coroutines in Python";
    homepage = "https://github.com/dabeaz/curio";
    changelog = "https://github.com/dabeaz/curio/raw/${version}/CHANGES";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
