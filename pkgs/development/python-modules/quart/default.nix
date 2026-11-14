{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # propagates
  aiofiles,
  blinker,
  click,
  flask,
  hypercorn,
  itsdangerous,
  jinja2,
  markupsafe,
  pydata-sphinx-theme,
  python-dotenv,
  werkzeug,

  # tests
  hypothesis,
  mock,
  py,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "quart";
  version = "0.23.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "quart";
    tag = version;
    hash = "sha256-AFocee/xYXsd88jlL3wttJ+iGXwYZKSPhiFHYUVpHWQ=";
  };

  build-system = [ flit-core ];

  dependencies = [
    aiofiles
    blinker
    click
    flask
    hypercorn
    itsdangerous
    jinja2
    markupsafe
    pydata-sphinx-theme
    python-dotenv
    werkzeug
  ];

  pythonImportsCheck = [ "quart" ];

  nativeCheckInputs = [
    hypothesis
    mock
    py
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError
    "test_cli_blueprints[cli_group2-args2]"
  ];

  meta = {
    description = "Async Python micro framework for building web applications";
    homepage = "https://github.com/pallets/quart/";
    changelog = "https://github.com/pallets/quart/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "quart";
  };
}
