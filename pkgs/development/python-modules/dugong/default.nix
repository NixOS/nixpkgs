{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonAtLeast
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dugong";
  version = "3.8.1";
  disabled = pythonOlder "3.3";

  src = fetchFromGitHub {
    owner = "python-dugong";
    repo = "python-dugong";
    rev = "release-${version}";
    sha256 = "1063c1779idc5nrjzfv5w1xqvyy3crapb2a2xll9y6xphxclnkjc";
  };

  checkInputs = [
    pytestCheckHook
  ];

  # Lots of tests hang during teardown with:
  #   ssl.SSLEOFError: EOF occurred in violation of protocol (_ssl.c:2396)
  doCheck = pythonOlder "3.10";

  pythonImportsCheck = [ "dugong" ];

  meta = with lib; {
    description = "HTTP 1.1 client designed for REST-ful APIs";
    homepage = "https://github.com/python-dugong/python-dugong/";
    license = with licenses; [ psfl asl20 ];
    maintainers = with maintainers; [ ];
  };
}
