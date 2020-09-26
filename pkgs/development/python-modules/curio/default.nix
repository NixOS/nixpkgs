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
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90f320fafb3f5b791f25ffafa7b561cc980376de173afd575a2114380de7939b";
  };

  disabled = !isPy3k;

  checkInputs = [ pytestCheckHook sphinx ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
     "test_aside_basic" # times out
     "test_aside_cancel" # fails because modifies PYTHONPATH and cant find pytest
     "test_ssl_outgoing" # touches network
   ] ++ lib.optionals (stdenv.isDarwin) [
     "test_unix_echo" # socket bind error on hydra when built with other packages
     "test_unix_ssl_server" # socket bind error on hydra when built with other packages
   ];

  meta = with lib; {
    homepage = "https://github.com/dabeaz/curio";
    description = "Library for performing concurrent I/O with coroutines in Python 3";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
