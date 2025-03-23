{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  # build-system
  poetry-core,

  # dependencies
  numpy,
  click,
  pillow,
  pydantic,
  pyparsing,
  typing-extensions,

  # optional dependencies
  pygls,
  lsprotocol,
  drawsvg,
  pygments,
  shapely,

  # test
  filelock,
  dulwich,
  tzlocal,
  pytest-xdist,
  pytest-cov,
  pytest-lsp,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,

}:

buildPythonPackage rec {
  pname = "pygerber";
  version = "2.4.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Argmaster";
    repo = "pygerber";
    tag = "v${version}";
    hash = "sha256-N+9I59WiWXSXr7RrPzb7GFSqfjrd0q51AzalNFV4xEQ=";
  };

  build-system = [ poetry-core ];
  dependencies = [
    numpy
    click
    pillow
    pydantic
    pyparsing
    typing-extensions
  ];

  passthru.optional-dependencies = {
    language_server = [
      pygls
      lsprotocol
    ];
    svg = [ drawsvg ];
    pygments = [ pygments ];
    shapely = [ shapely ];
    all = [
      pygls
      lsprotocol
      drawsvg
      pygments
      shapely
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov
    pytest-xdist
    pytest-lsp
    pytest-mock
    pytestCheckHook
    tzlocal
    drawsvg
    dulwich
    filelock
  ];

  disabledTestPaths = [
    # require network access
    "test/gerberx3/test_assets.py"
    "test/gerberx3/test_language_server/tests.py"
  ];

  pythonImportsCheck = [ "pygerber" ];

  meta = {
    description = "Implementation of the Gerber X3/X2 format, based on Ucamco's The Gerber Layer Format Specification";
    homepage = "https://github.com/Argmaster/pygerber";
    changelog = "https://argmaster.github.io/pygerber/stable/Changelog.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ clemjvdm ];
  };
}
