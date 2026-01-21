{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  yarnConfigHook,
  fetchYarnDeps,
  nodejs,

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
  kombu,
  redis,
  diskcache,
  multiprocess,
  psutil,
  flask-compress,

  flaky,
  numpy,
  pytestCheckHook,
  pytest-mock,
  mock,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "dash";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "dash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Vt109x4T+DhBXfQf7MKoexmWFc23uuU0Nn3Ia/Xm5I=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    nodejs
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/@plotly/dash-jupyterlab/yarn.lock";
    hash = "sha256-Nvm9BS55q/HW9ArpHD01F5Rmx8PLS3yqaz1yDK8Sg68=";
  };

  # as of writing this yarnConfigHook has no parameter that changes in which directory it will be run
  # until then we use preConfigure for entering the directory and preBuild for exiting it
  preConfigure = ''
    pushd @plotly/dash-jupyterlab

    substituteInPlace package.json \
        --replace-fail 'jlpm' 'yarn'
  '';

  preBuild = ''
    # Generate the jupyterlab extension files
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

  pythonRelaxDeps = [
    "werkzeug"
    "flask"
  ];

  optional-dependencies = {
    celery = [
      celery
      kombu
      redis
    ]
    ++ celery.optional-dependencies.redis;
    diskcache = [
      diskcache
      multiprocess
      psutil
    ];
    compress = [ flask-compress ];
  };

  nativeCheckInputs = [
    flaky
    numpy
    psutil
    pytestCheckHook
    pytest-mock
    mock
    pyyaml
    redis
  ];

  enabledTestPaths = [
    "tests/unit"
  ];

  disabledTestPaths = [
    "tests/unit/test_browser.py"
    "tests/unit/test_app_runners.py" # Uses selenium
  ];

  pythonImportsCheck = [ "dash" ];

  meta = {
    changelog = "https://github.com/plotly/dash/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Python framework for building analytical web applications";
    homepage = "https://dash.plot.ly/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      antoinerg
      tomasajt
    ];
  };
})
