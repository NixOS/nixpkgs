{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, irctokens
, pendulum
, freezegun
, python
}:

buildPythonPackage rec {
  pname = "ircstates";
  version = "0.12.1";
  disabled = pythonOlder "3.6";  # f-strings

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-F9yOY3YBacyoUzNTvPs7pxp6yNx08tiq1jWQKhGiagc=";
  };

  propagatedBuildInputs = [
    irctokens
    pendulum
  ];

  nativeCheckInputs = [
    freezegun
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
