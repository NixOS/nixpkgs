{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  nodejs,
  yarn,
  fixup-yarn-lock,
  fetchYarnDeps,

  setuptools,
  flask,
  werkzeug,
  plotly,
  dash-html-components,
  dash-core-components,
  dash-table,
  importlib-metadata,
  typing-extensions,
  requests,
  retrying,
  nest-asyncio,

  celery,
  redis,
  diskcache,
  multiprocess,
  psutil,
  flask-compress,

  pytestCheckHook,
  pytest-mock,
  mock,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "dash";
  version = "2.16.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "dash";
    rev = "refs/tags/v${version}";
    hash = "sha256-IPyGQXrC2FTTSIC4IFGwKTceyzPYAe4jwDoO5C9YeF0=";
  };

  nativeBuildInputs = [
    nodejs
    yarn
    fixup-yarn-lock
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/@plotly/dash-jupyterlab/yarn.lock";
    hash = "sha256-L/or8jO6uEypI5krwy/ElIxa6jJrXGsCRZ9mh+0kcGA=";
  };

  preBuild = ''
    pushd @plotly/dash-jupyterlab

    export HOME=$(mktemp -d)

    yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
    fixup-yarn-lock yarn.lock
    substituteInPlace package.json --replace-fail jlpm yarn
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts
    patchShebangs node_modules

    # Generates the jupyterlab extension files
    yarn --offline run build:pack

    popd
  '';

  build-system = [ setuptools ];

  dependencies = [
    flask
    werkzeug
    plotly
    dash-html-components
    dash-core-components
    dash-table
    importlib-metadata
    typing-extensions
    requests
    retrying
    nest-asyncio
  ];

  optional-dependencies = {
    celery = [
      celery
      redis
    ];
    diskcache = [
      diskcache
      multiprocess
      psutil
    ];
    compress = [ flask-compress ];
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
    changelog = "https://github.com/plotly/dash/blob/${src.rev}/CHANGELOG.md";
    description = "Python framework for building analytical web applications";
    homepage = "https://dash.plot.ly/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      antoinerg
      tomasajt
    ];
  };
}
