{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  docstring-to-markdown,
  jedi,
  lsprotocol,
  pydantic,
  pygls,

  # tests
  pytestCheckHook,
  pyhamcrest,
  python-lsp-jsonrpc,
}:

buildPythonPackage rec {
  pname = "jedi-language-server";
  version = "0.44.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pappasam";
    repo = "jedi-language-server";
    tag = "v${version}";
    hash = "sha256-b3wty4ir/JHh3018Kk0zyX7mM2yrE5n0f2YoidnSIw8=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
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

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # https://github.com/pappasam/jedi-language-server/issues/313
    "test_publish_diagnostics_on_change"
    "test_publish_diagnostics_on_save"
  ];

  pythonImportsCheck = [ "jedi_language_server" ];

  meta = {
    description = "Language Server for the latest version(s) of Jedi";
    mainProgram = "jedi-language-server";
    homepage = "https://github.com/pappasam/jedi-language-server";
    changelog = "https://github.com/pappasam/jedi-language-server/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
