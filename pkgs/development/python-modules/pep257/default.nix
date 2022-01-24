{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, mock }:

buildPythonPackage rec {
  pname = "pep257";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "GreenSteam";
    repo = "pep257";
    rev = version;
    sha256 = "sha256-RkE9kkNkRTmZ8zJVwQzMsxU1hcjlxX6UA+ehnareynQ=";
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
