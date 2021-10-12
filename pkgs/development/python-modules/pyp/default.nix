{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, coreutils
, pythonOlder
, astunparse
, jq
, bc
}:

buildPythonPackage rec {
  pname = "pyp";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "hauntsaninja";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-K9dGmvy4siurmhqwNfg1dT0TWc6tCSaxfPyaJkYM2Vw=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.9") [
    astunparse
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';
  checkInputs = [
    pytestCheckHook
    coreutils
    jq
    bc
  ];

  meta = with lib; {
    description = "Easily run Python at the shell! Magical, but never mysterious.";
    homepage = "https://github.com/hauntsaninja/pyp";
    license = licenses.mit;
    maintainers = with maintainers; [ rmcgibbo ];
   };
}
