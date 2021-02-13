{ lib, buildPythonPackage, pythonOlder, fetchFromGitHub, pytestCheckHook, requests }:

buildPythonPackage rec {
  pname = "fritzconnection";
  version = "1.4.1";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "kbr";
    repo = pname;
    rev = version;
    sha256 = "1v8gyr91ddinxgl7507hw64snsvcpm3r7bmdjw2v5v6rmc0wl06s";
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
