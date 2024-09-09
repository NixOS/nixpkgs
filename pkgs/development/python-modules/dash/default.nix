{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  setuptools,
  nodejs,
  yarn,
  fixup-yarn-lock,
  fetchYarnDeps,

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
  version = "2.17.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "dash";
    rev = "refs/tags/v${version}";
    hash = "sha256-51/nMnXUhb+hTL4xS9x4urI+2eENo/8sEKtk/kt6xTk=";
  };

  nativeBuildInputs = [
    setuptools
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

    substituteInPlace package.json --replace jlpm yarn
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts
    patchShebangs node_modules

    # Generates the jupyterlab extension files
    yarn run build:pack

    popd
  '';

  propagatedBuildInputs = [
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
