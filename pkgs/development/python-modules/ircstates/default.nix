{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, irctokens
, pendulum
, python
}:

buildPythonPackage rec {
  pname = "ircstates";
  version = "0.11.8";
  disabled = pythonOlder "3.6";  # f-strings

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0scxqcgby4vzh2q937r0wy2mb46aghjf47q3z6fp6di1b6hlj7zh";
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
