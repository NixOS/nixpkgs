{
  lib,
  aenum,
  aiohttp,
  appdirs,
  buildPythonPackage,
  certifi,
  diff-match-patch,
  fetchFromGitHub,
  flake8,
  importlib-metadata,
  livereload,
  mypy,
  networkx,
  ordered-set,
  pillow,
  pixelmatch,
  poetry-core,
  pre-commit,
  pydocstyle,
  pyee,
  pylint,
  pytest,
  pytest-cov,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  readme-renderer,
  sphinx,
  sphinxcontrib-asyncio,
  syncer,
  tox,
  tqdm,
  typing-extensions,
  typing-inspect,
  urllib3,
  websockets,
}:

buildPythonPackage rec {
  pname = "pyppeteer-ng";
  version = "2.0.0rc10";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dgtlmoon";
    repo = "pyppeteer-ng";
    tag = version;
    hash = "sha256-NpxjKsh12pr/MCZ4gfoaa+3jTYyvQzHgSno1+rw2Wk0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'aenum = "^2.2.3"' 'aenum = "*"' \
      --replace-fail 'typing_inspect = { version ="^0.5.0"' 'typing_inspect = { version ="*"' \
      --replace-fail 'urllib3 = "^1.25.8"' 'urllib3 = "*"' \
      --replace-fail 'websockets = "^10.1"' 'websockets = "*"' \
      --replace-fail 'requires = ["poetry>=0.12"]' 'requires = ["poetry-core"]' \
      --replace-fail 'build-backend = "poetry.masonry.api"' 'build-backend = "poetry.core.masonry.api"'

    substituteInPlace tests/conftest.py \
      --replace-fail '_port = get_free_port()' ""

    substituteInPlace tests/utils/server.py \
      --replace-fail '_Middleware' '_Middlewares' \
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aenum
    appdirs
    certifi
    ordered-set
    pillow
    pyee
    tqdm
    typing-inspect
    typing-extensions
    urllib3
    websockets
  ];

  nativeCheckInputs = [
    aiohttp
    diff-match-patch
    flake8
    livereload
    mypy
    networkx
    pixelmatch
    pre-commit
    pydocstyle
    pylint
    pytest
    pytest-cov
    pytest-timeout
    pytest-xdist
    readme-renderer
    sphinx
    sphinxcontrib-asyncio
    syncer
    tox
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_abnormal_crash.py"
    "tests/test_accessibility.py"
    "tests/test_browser.py"
    "tests/test_browser_context.py"
    "tests/test_browser_fetcher.py"
    "tests/test_click.py"
    "tests/test_connection.py"
    "tests/test_coverage.py"
    "tests/test_dialog.py"
    "tests/test_element_handle.py"
    "tests/test_emulation.py"
    "tests/test_execution_context.py"
    "tests/test_frame.py"
    "tests/test_input.py"
    "tests/test_jshandle.py"
    "tests/test_keyboard.py"
    "tests/test_launcher.py"
    "tests/test_mouse.py"
    "tests/test_navigation.py"
    "tests/test_page.py"
    "tests/test_pyppeteer.py"
    "tests/test_queryselector.py"
    "tests/test_requestinterception.py"
    "tests/test_screenshot.py"
    "tests/test_target.py"
    "tests/test_touchscreen.py"
    "tests/test_tracing.py"
    "tests/test_worker.py"

    # Failing
    "pyee12-compat/connection_stability_test.py"
    "pyee12-compat/pyee_compatibility_test.py"
    "pyee12-compat/real_websocket_test.py"
    "pyee12-compat/simple_connection_test.py"
    "pyee12-compat/simplified_test.py"
    "tests/test_misc.py"
  ];

  pythonImportsCheck = [ "pyppeteer" ];

  meta = with lib; {
    description = "Headless chrome/chromium automation library (unofficial port of puppeteer)";
    mainProgram = "pyppeteer-install";
    homepage = "https://github.com/dgtlmoon/pyppeteer-ng";
    changelog = "https://github.com/dgtlmoon/pyppeteer-ng/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ thanegill ];
  };
}
