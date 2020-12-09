{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, irctokens
, pendulum
, python
}:

buildPythonPackage rec {
  pname = "ircstates";
  version = "0.11.6";
  disabled = pythonOlder "3.6";  # f-strings

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yhrd1nmf9fjwknbga8wspy3bab40lgp4qqnr7w75x9wq5ivmqhg";
  };

  propagatedBuildInputs = [
    irctokens
    pendulum
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest test
  '';

  pythonImportsCheck = [ "ircstates" ];

  meta = with lib; {
    description = "sans-I/O IRC session state parsing library";
    license = licenses.mit;
    homepage = "https://github.com/jesopo/ircstates";
    maintainers = with maintainers; [ hexa ];
  };
}
