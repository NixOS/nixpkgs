{ lib, buildPythonPackage, fetchFromGitHub, pytest, mock }:
buildPythonPackage rec {
  pname = "pep257";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "GreenSteam";
    repo = "pep257";
    rev = "0.7.0";
    sha256 = "sha256-RkE9kkNkRTmZ8zJVwQzMsxU1hcjlxX6UA+ehnareynQ=";
  };

  checkInputs = [ pytest mock ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = "https://github.com/GreenSteam/pep257/";
    description = "Python docstring style checker";
    longDescription = "Static analysis tool for checking compliance with Python PEP 257.";
    license = licenses.mit;
  };
}
