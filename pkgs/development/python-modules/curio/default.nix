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
  version = "1.5";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rwghLlkLt9qOTMOcQgEnEUlNwg1iLxYhVbopbMLjvBA=";
  };

  checkInputs = [
    pytestCheckHook
    sphinx
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
     "test_aside_basic" # times out
     "test_write_timeout" # flaky, does not always time out
     "test_aside_cancel" # fails because modifies PYTHONPATH and cant find pytest
     "test_ssl_outgoing" # touches network
   ] ++ lib.optionals stdenv.isDarwin [
     "test_unix_echo" # socket bind error on hydra when built with other packages
     "test_unix_ssl_server" # socket bind error on hydra when built with other packages
   ];

  pythonImportsCheck = [ "curio" ];

  meta = with lib; {
    homepage = "https://github.com/dabeaz/curio";
    description = "Library for performing concurrent I/O with coroutines in Python";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
