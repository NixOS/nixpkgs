{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
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
, pytestCheckHook
, pytest-cov
, pytest-asyncio
, hypothesis
, mock
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

  patches = [
    # see https://github.com/pallets/quart/issues/202
    (fetchpatch {
      name = "fix-py-module-issues";
      url = "https://github.com/pallets/quart/commit/88b9691a554f8b5676ec5c21d602203a9ab0d401.patch";
      hash = "sha256-jTeTy24d5aO84PenvJ5efFHuIStVw7ev3qCLyd3PU2U=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

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

  checkInputs = [
    pytestCheckHook
    pytest-cov
    pytest-asyncio
    hypothesis
    mock
  ];

  meta = with lib; {
    changelog = "https://github.com/pallets/quart/releases/tag/${version}";
    description = "An async Python micro framework for building web applications.";
    homepage = "https://github.com/pallets/quart";
    license = licenses.mit;
    maintainers = with maintainers; [ felschr ];
  };
}
