{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pytestCheckHook
, sphinx
, stdenv
}:

buildPythonPackage rec {
  pname = "curio";
  version = "1.5";
  disabled = !isPy3k;

  src = fetchFromGitHub {
     owner = "dabeaz";
     repo = "curio";
     rev = "1.5";
     sha256 = "06rvcqs8qysdl7sn1h5w53s0xfgmrqvmdxp9ycbfh0y8ff1c582w";
  };

  checkInputs = [
    pytestCheckHook
    sphinx
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
     "test_aside_basic" # times out
     "test_aside_cancel" # fails because modifies PYTHONPATH and cant find pytest
     "test_ssl_outgoing" # touches network
   ] ++ lib.optionals (stdenv.isDarwin) [
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
