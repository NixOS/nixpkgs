{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, poetry-core

# propagates
, aiofiles
, blinker
, click
, flask
, hypercorn
, importlib-metadata
, itsdangerous
, jinja2
, markupsafe
, pydata-sphinx-theme
, python-dotenv
, typing-extensions
, werkzeug

# tests
, hypothesis
, mock
, py
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "quart";
  version = "0.19.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "quart";
    rev = "refs/tags/${version}";
    hash = "sha256-T2+76AVvXrads7AbjNAExV0i4doQ2xIUEwekVB2JXAo=";
  };

  build-system = [
    poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--no-cov-on-fail " ""
  '';

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
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
    typing-extensions
  ];

  pythonImportsCheck = [
    "quart"
  ];

  nativeCheckInputs = [
    hypothesis
    mock
    py
    pytest-asyncio
    pytestCheckHook
  ];

  meta = with lib; {
    description = "An async Python micro framework for building web applications";
    mainProgram = "quart";
    homepage = "https://github.com/pallets/quart/";
    changelog = "https://github.com/pallets/quart/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
