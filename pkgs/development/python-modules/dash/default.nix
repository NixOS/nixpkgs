{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub

, nodejs
, yarn
, fixup_yarn_lock
, fetchYarnDeps

, setuptools
, flask
, werkzeug
, plotly
, dash-html-components
, dash-core-components
, dash-table
, typing-extensions
, requests
, retrying
, ansi2html
, nest-asyncio

, celery
, redis
, diskcache
, multiprocess
, psutil
, flask-compress

, pytestCheckHook
, pytest-mock
, mock
, pyyaml
}:

buildPythonPackage rec {
  pname = "dash";
  version = "2.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "plotly";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+pTxEPuXtcu+ZekphqXD/k2tQ5werH/1ueGJOxA8pZw=";
  };

  nativeBuildInputs = [
    nodejs
    yarn
    fixup_yarn_lock
  ];

  yarnDeps = fetchYarnDeps {
    yarnLock = src + "/@plotly/dash-jupyterlab/yarn.lock";
    hash = "sha256-mkiyrA0jGiP0zbabSjgHFLEUX3f+LZdJ8eARI5QA8CU=";
  };

  preBuild = ''
    pushd @plotly/dash-jupyterlab

    export HOME=$(mktemp -d)

    yarn config --offline set yarn-offline-mirror ${yarnDeps}
    fixup_yarn_lock yarn.lock

    substituteInPlace package.json --replace jlpm yarn
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts
    patchShebangs .

    # Generates the jupyterlab extension files
    yarn run build:pack

    popd
  '';

  propagatedBuildInputs = [
    setuptools # for importing pkg_resources
    flask
    werkzeug
    plotly
    dash-html-components
    dash-core-components
    dash-table
    typing-extensions
    requests
    retrying
    ansi2html
    nest-asyncio
  ];

  passthru.optional-dependencies = {
    celery = [
      celery
      redis
    ];
    diskcache = [
      diskcache
      multiprocess
      psutil
    ];
    compress = [
      flask-compress
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    mock
    pyyaml
  ];

  disabledTestPaths = [
    "tests/unit/test_browser.py"
    "tests/unit/test_app_runners.py" # Uses selenium
    "tests/integration"
  ];

  pythonImportsCheck = [ "dash" ];

  meta = {
    description = "Python framework for building analytical web applications";
    homepage = "https://dash.plot.ly/";
    changelog = "https://github.com/plotly/dash/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ antoinerg tomasajt ];
  };
}
