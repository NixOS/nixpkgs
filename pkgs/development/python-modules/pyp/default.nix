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
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hauntsaninja";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-A1Ip41kxH17BakHEWEuymfa24eBEl5FIHAWL+iZFM4I=";
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
