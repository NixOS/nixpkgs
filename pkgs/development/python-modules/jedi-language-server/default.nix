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
  version = "0.41.1-unstable-2023-10-04";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pappasam";
    repo = pname;
    rev = "c4c470cff67e54593a626b22d1b6b05e56fde3a3";
    hash = "sha256-qFBni97B/GkabbznnZtWTG4dCHFkOx5UQjuevxq+Uvo=";
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
