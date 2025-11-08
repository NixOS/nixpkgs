{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  configurable-http-proxy,

  # nativeBuildInputs
  nodejs,
  npmHooks,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  alembic,
  certipy,
  idna,
  jinja2,
  jupyter-events,
  oauthlib,
  packaging,
  pamela,
  prometheus-client,
  pydantic,
  python-dateutil,
  requests,
  sqlalchemy,
  tornado,
  traitlets,
  pythonOlder,
  async-generator,
  importlib-metadata,

  # tests
  addBinToPathHook,
  beautifulsoup4,
  cryptography,
  jsonschema,
  jupyterlab,
  mock,
  nbclassic,
  playwright,
  pytest-asyncio,
  pytestCheckHook,
  requests-mock,
  versionCheckHook,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "jupyterhub";
  version = "5.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "jupyterhub";
    tag = version;
    hash = "sha256-eSYoLoPWHQ/HHAFW6X262hrIrmUxDxrYEzVFiwGVqCs=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-IlY0dRHXsrEWNfBqUSk7hwU+CmlUfGPtXTPNcOBT8Bw=";
  };

  postPatch = ''
    substituteInPlace jupyterhub/proxy.py \
      --replace-fail \
        "'configurable-http-proxy'" \
        "'${lib.getExe configurable-http-proxy}'"

    substituteInPlace jupyterhub/tests/test_proxy.py \
      --replace-fail \
        "'configurable-http-proxy'" \
        "'${lib.getExe configurable-http-proxy}'"
  '';

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    alembic
    certipy
    idna
    jinja2
    jupyter-events
    oauthlib
    packaging
    pamela
    prometheus-client
    pydantic
    python-dateutil
    requests
    sqlalchemy
    tornado
    traitlets
  ]
  ++ lib.optionals (pythonOlder "3.10") [
    async-generator
    importlib-metadata
  ];

  pythonImportsCheck = [ "jupyterhub" ];

  nativeCheckInputs = [
    addBinToPathHook
    beautifulsoup4
    cryptography
    jsonschema
    jupyterlab
    mock
    nbclassic
    playwright
    # require pytest-asyncio<0.23
    # https://github.com/jupyterhub/jupyterhub/pull/4663
    (pytest-asyncio.overrideAttrs (
      final: prev: {
        version = "0.21.2";
        src = fetchFromGitHub {
          inherit (prev.src) owner repo;
          rev = "refs/tags/v${final.version}";
          hash = "sha256-AVVvdo/CDF9IU6l779sLc7wKz5h3kzMttdDNTPLYxtQ=";
        };
      }
    ))
    pytestCheckHook
    requests-mock
    versionCheckHook
    virtualenv
  ];
  versionCheckProgramArg = "--version";

  disabledTests = [
    # Tries to install older versions through pip
    "test_upgrade"
    # Testcase fails to find requests import
    "test_external_service"
    # Attempts to do TLS connection
    "test_connection_notebook_wrong_certs"
    # AttributeError: 'coroutine' object...
    "test_valid_events"
    "test_invalid_events"
    "test_user_group_roles"
  ];

  disabledTestPaths = [
    # Not testing with a running instance
    # AttributeError: 'coroutine' object has no attribute 'db'
    "docs/test_docs.py"
    "jupyterhub/tests/browser/test_browser.py"
    "jupyterhub/tests/test_api.py"
    "jupyterhub/tests/test_auth_expiry.py"
    "jupyterhub/tests/test_auth.py"
    "jupyterhub/tests/test_metrics.py"
    "jupyterhub/tests/test_named_servers.py"
    "jupyterhub/tests/test_orm.py"
    "jupyterhub/tests/test_pages.py"
    "jupyterhub/tests/test_proxy.py"
    "jupyterhub/tests/test_scopes.py"
    "jupyterhub/tests/test_services_auth.py"
    "jupyterhub/tests/test_singleuser.py"
    "jupyterhub/tests/test_spawner.py"
    "jupyterhub/tests/test_user.py"
  ];

  meta = {
    description = "Serves multiple Jupyter notebook instances";
    homepage = "https://github.com/jupyterhub/jupyterhub";
    changelog = "https://github.com/jupyterhub/jupyterhub/blob/${version}/docs/source/reference/changelog.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
    badPlatforms = [
      # E   OSError: dlopen(/nix/store/43zml0mlr17r5jsagxr00xxx91hz9lky-openpam-20170430/lib/libpam.so, 6): image not found
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
