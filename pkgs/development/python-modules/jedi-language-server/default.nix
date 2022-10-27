{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, poetry
, docstring-to-markdown
, jedi
, pygls
, pytestCheckHook
, pyhamcrest
, python-jsonrpc-server
}:

buildPythonPackage rec {
  pname = "jedi-language-server";
  version = "0.37.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pappasam";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-5il12WDmUkdud9zTpzTaoSXEqOaK15Ut3/fUAX422fA=";
  };

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    docstring-to-markdown
    jedi
    pygls
  ];

  checkInputs = [
    pytestCheckHook
    pyhamcrest
    python-jsonrpc-server
  ];

  preCheck = ''
    HOME="$(mktemp -d)"
  '';

  pythonImportsCheck = [
    "jedi_language_server"
  ];

  meta = with lib; {
    homepage = "https://github.com/pappasam/jedi-language-server";
    description = "A Language Server for the latest version(s) of Jedi";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
