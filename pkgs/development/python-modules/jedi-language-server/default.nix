{ lib
, buildPythonPackage
, docstring-to-markdown
, fetchFromGitHub
, jedi
, lsprotocol
, poetry-core
, pygls
, pydantic
, pyhamcrest
, pytestCheckHook
, python-lsp-jsonrpc
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jedi-language-server";
  version = "0.41.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pappasam";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+k4WOoEbVe7mlPyPj0ttBM+kmjq8V739yHi36BDYK2U=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    docstring-to-markdown
    jedi
    lsprotocol
    pydantic
    pygls
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyhamcrest
    python-lsp-jsonrpc
  ];

  preCheck = ''
    HOME="$(mktemp -d)"
  '';

  pythonImportsCheck = [
    "jedi_language_server"
  ];

  meta = with lib; {
    description = "A Language Server for the latest version(s) of Jedi";
    mainProgram = "jedi-language-server";
    homepage = "https://github.com/pappasam/jedi-language-server";
    changelog = "https://github.com/pappasam/jedi-language-server/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
