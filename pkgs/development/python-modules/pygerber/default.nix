{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

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
  pytest-lsp,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,

}:

buildPythonPackage rec {
  pname = "pygerber";
  version = "2.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Argmaster";
    repo = "pygerber";
    tag = "v${version}";
    hash = "sha256-0AoRmIN1FNlummJSHdysO2IDBHtfNPhVnh9j0lyWNFI=";
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

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # FileNotFoundError: [Errno 2] No such file or directory: 'open'
    "test_project_render_with_file_type_tags"
  ];

  pytestFlags = [ "--override-ini=required_plugins=" ];

  pythonImportsCheck = [ "pygerber" ];

  meta = {
    description = "Implementation of the Gerber X3/X2 format, based on Ucamco's The Gerber Layer Format Specification";
    homepage = "https://github.com/Argmaster/pygerber";
    changelog = "https://argmaster.github.io/pygerber/stable/Changelog.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ clemjvdm ];
  };
}
