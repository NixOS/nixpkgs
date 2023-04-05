{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, poetry-core

# propagates
, aiofiles
, blinker
, click
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
  version = "0.18.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "quart";
    rev = "refs/tags/${version}";
    hash = "sha256-aQM8kEhienBG+/zQQ8C/DKiDIMF3l9rq8HSAvg7wvLM=";
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
    hypercorn
    importlib-metadata
    itsdangerous
    jinja2
    markupsafe
    pydata-sphinx-theme
    python-dotenv
    typing-extensions
    werkzeug
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
    homepage = "https://github.com/pallets/quart/";
    changelog = "https://github.com/pallets/quart/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
