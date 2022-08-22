{ lib
, buildPythonPackage
, fetchFromGitHub
, lark
, pydot
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "amarna";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "amarna";
    rev = "v${version}";
    sha256 = "sha256-ohR6VJFIvUCMkppqdCV/kJwEmh1fP0QhfQfNu3RoMeU=";
  };

  propagatedBuildInputs = [
    lark
    pydot
  ];
  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "amarna" ];

  meta = with lib; {
    description = "Amarna is a static-analyzer and linter for the Cairo programming language.";
    homepage = "https://github.com/crytic/amarna";
    license = licenses.agpl3;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
