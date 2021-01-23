{ lib, stdenv, buildPythonPackage, pythonOlder, fetchFromGitHub, pytestCheckHook, requests }:

buildPythonPackage rec {
  pname = "fritzconnection";
  version = "1.4.0";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "kbr";
    repo = pname;
    rev = version;
    sha256 = "1p8dqcc75xfhyvc9izjzz8c7qfrdkjkrkj36j7ms5fimn5bwk70q";
  };

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python-Tool to communicate with the AVM FritzBox using the TR-064 protocol";
    homepage = "https://github.com/kbr/fritzconnection";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda valodim ];
  };
}
