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
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "quart";
    tag = version;
    hash = "sha256-BrZtknO8Xne5r4CENF0Uz8NVc8Zc+Yu35spvPw7qZ/w=";
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

  meta = {
    description = "Async Python micro framework for building web applications";
    mainProgram = "quart";
    homepage = "https://github.com/pallets/quart/";
    changelog = "https://github.com/pallets/quart/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
