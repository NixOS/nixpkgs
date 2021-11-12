{ lib
, buildPythonPackage
, fetchFromGitHub
, argcomplete
, jmespath
, pygments
, pyyaml
, tabulate
, mock
, vcrpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "knack";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kjg62slxy6ixb3af72qg6n9vid78bh29vh3vaq3vsk5yxz5az2y";
  };

  propagatedBuildInputs = [
    argcomplete
    jmespath
    pygments
    pyyaml
    tabulate
  ];

  checkInputs = [
    vcrpy
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    "knack"
  ];

  meta = with lib; {
    description = "A Command-Line Interface framework";
    homepage = "https://github.com/microsoft/knack";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
