{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lark,
  pydot,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "amarna";
  version = "0.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "amarna";
    tag = "v${version}";
    hash = "sha256-tyvHWBhanR7YH87MDWdXUsDEzZG6MgnbshezAbxWO+I=";
  };

  propagatedBuildInputs = [
    lark
    pydot
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "amarna" ];

  meta = with lib; {
    description = "Static-analyzer and linter for the Cairo programming language";
    mainProgram = "amarna";
    homepage = "https://github.com/crytic/amarna";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
