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
  version = "0.11.7";
  disabled = pythonOlder "3.6";  # f-strings

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = pname;
    rev = "v${version}";
    sha256 = "00dyd6mry10na98x1gs92xnfpjf1wd9zpblx1wcx8ggv5rqvgqrm";
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
