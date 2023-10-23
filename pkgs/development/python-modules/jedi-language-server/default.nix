{ lib
, buildPythonPackage
, docstring-to-markdown
, fetchFromGitHub
, cattrs
, jedi
, lsprotocol
, poetry-core
, pygls
, pyhamcrest
, pytestCheckHook
, python-lsp-jsonrpc
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "jedi-language-server";
  version = "0.41.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pappasam";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+ABxH1iF9FDQ7q6dAQowe3AJSgz+wgCy4JS35WpcnTs=";
  };

  pythonRelaxDeps = [
    "pygls"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    cattrs
    docstring-to-markdown
    jedi
    lsprotocol
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
