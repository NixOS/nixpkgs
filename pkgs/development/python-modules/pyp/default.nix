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
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hauntsaninja";
    repo = pname;
    rev = "v${version}";
    sha256 = "09k7y77h7g4dg0x6lg9pn2ga9z7xiy4vlj15fj0991ffsi4ydqgm";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.9") [
    astunparse
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  nativeCheckInputs = [
    pytestCheckHook
    coreutils
    jq
    bc
  ];

  pythonImportsCheck = [
    "pyp"
  ];

  meta = with lib; {
    description = "Easily run Python at the shell! Magical, but never mysterious";
    homepage = "https://github.com/hauntsaninja/pyp";
    license = licenses.mit;
    maintainers = with maintainers; [ rmcgibbo ];
   };
}
