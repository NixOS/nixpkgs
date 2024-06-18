{
  lib,
  buildPythonPackage,
  docstring-to-markdown,
  fetchFromGitHub,
  jedi,
  lsprotocol,
  poetry-core,
  pygls,
  pydantic,
  pyhamcrest,
  pytestCheckHook,
  python-lsp-jsonrpc,
  pythonOlder,
  stdenv,
}:

buildPythonPackage rec {
  pname = "jedi-language-server";
  version = "0.41.4";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pappasam";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-RDLwL9AZ3G8CzVwDtWqFFZNH/ulpHeFBhglbWNv/ZIk=";
  };

  nativeBuildInputs = [ poetry-core ];

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

  disabledTests = lib.optionals stdenv.isDarwin [
    # https://github.com/pappasam/jedi-language-server/issues/313
    "test_publish_diagnostics_on_change"
    "test_publish_diagnostics_on_save"
  ];

  pythonImportsCheck = [ "jedi_language_server" ];

  meta = with lib; {
    description = "Language Server for the latest version(s) of Jedi";
    mainProgram = "jedi-language-server";
    homepage = "https://github.com/pappasam/jedi-language-server";
    changelog = "https://github.com/pappasam/jedi-language-server/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
