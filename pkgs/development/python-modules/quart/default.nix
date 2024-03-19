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
  version = "0.19.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "quart";
    rev = "refs/tags/${version}";
    hash = "sha256-EgCZ0AXK2vGxo55BWAcDVv6zNUrWNbAYNnEXEBJk+84=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--no-cov-on-fail " ""
  '';

  propagatedBuildInputs = [
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

  pytestFlagsArray = [
    # pytest.PytestRemovedIn8Warning: Passing None has been deprecated.
    "-W" "ignore::pytest.PytestRemovedIn8Warning"
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
