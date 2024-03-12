{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, coreutils
, pythonOlder
, astunparse
, flit-core
, jq
, bc
}:

buildPythonPackage rec {
  pname = "pyp";
  version = "1.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hauntsaninja";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hnEgqWOIVj2ugOhd2aS9IulfkVnrlkhwOtrgH4qQqO8=";
  };

  nativeBuildInputs = [
    flit-core
  ];

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
