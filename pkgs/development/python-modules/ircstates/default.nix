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
  version = "0.11.5";
  disabled = pythonOlder "3.6";  # f-strings

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1b1py1q02wbp4fmkjvchvazklfqibqd6pb28gdq7dg1bwwwd7vda";
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
