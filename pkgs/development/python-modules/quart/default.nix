{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  flit-core,

  # propagates
  aiofiles,
  blinker,
  click,
  flask,
  hypercorn,
  importlib-metadata,
  itsdangerous,
  jinja2,
  markupsafe,
  pydata-sphinx-theme,
  python-dotenv,
  typing-extensions,
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
  version = "0.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "quart";
    tag = version;
    hash = "sha256-NApev3nRBS4QDMGq8++rSmK5YgeljkaVAsdezsTbZr4=";
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
  ]
  ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
    typing-extensions
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

  meta = with lib; {
    description = "Async Python micro framework for building web applications";
    mainProgram = "quart";
    homepage = "https://github.com/pallets/quart/";
    changelog = "https://github.com/pallets/quart/blob/${src.tag}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
