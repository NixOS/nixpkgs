{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pyyaml
, python
}:

buildPythonPackage rec {
  pname = "irctokens";
  version = "2.0.1";
  disabled = pythonOlder "3.6";  # f-strings

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FgcLngS11U9eBNV/8jllwdrm89tCmthA1sUaFDovk6U=";
  };

  nativeCheckInputs = [ pyyaml ];
  checkPhase = ''
    ${python.interpreter} -m unittest test
  '';

  pythonImportsCheck = [ "irctokens" ];

  meta = with lib; {
    description = "RFC1459 and IRCv3 protocol tokeniser library for python3";
    license = licenses.mit;
    homepage = "https://github.com/jesopo/irctokens";
    maintainers = with maintainers; [ hexa ];
  };
}
