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
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "jedi-language-server";
  version = "0.41.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pappasam";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1ujEhoxWcCM1g640aLE60YGiNQLB+G7t7oLVZXW8AMM=";
  };

  pythonRelaxDeps = [
    "pygls"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
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
    homepage = "https://github.com/pappasam/jedi-language-server";
    changelog = "https://github.com/pappasam/jedi-language-server/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
