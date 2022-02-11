{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, mock }:

buildPythonPackage rec {
  pname = "pep257";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "GreenSteam";
    repo = "pep257";
    rev = version;
    sha256 = "0hcf3nyvzl8kd6gmc9qsiigz7vpwrjxcd1bd50dd63cad87qqicg";
  };

  checkInputs = [ pytestCheckHook mock ];

  meta = with lib; {
    homepage = "https://github.com/GreenSteam/pep257/";
    description = "Python docstring style checker";
    longDescription = "Static analysis tool for checking compliance with Python PEP 257.";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
