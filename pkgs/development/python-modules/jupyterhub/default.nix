{
  lib,
  stdenv,
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
  # darwin-only
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jupyterhub";
  version = "5.4.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "jupyterhub";
    tag = finalAttrs.version;
    hash = "sha256-ndL5pE332VDlCk16XYUDaXhsg/J8ndGtgDhKct+y26c=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-64FRdLHBpnywpCLjsMoXmWp/tK00+QwNIR9yAoQFIbg=";
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
    pytest-asyncio
    pytestCheckHook
    requests-mock
    versionCheckHook
    virtualenv
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # PermissionError: [Errno 13] Permission denied:
    # '/private/tmp/temp_user_1/Library/Jupyter/runtime/jpserver-45402-open.html'
    writableTmpDirAsHomeHook
  ];

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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Server connection times out under load on Darwin
    "test_server_token_role"
    "test_share_flow_full"
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

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Serves multiple Jupyter notebook instances";
    homepage = "https://github.com/jupyterhub/jupyterhub";
    changelog = "https://github.com/jupyterhub/jupyterhub/blob/${finalAttrs.src.tag}/docs/source/reference/changelog.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
    badPlatforms = [
      # E   OSError: dlopen(/nix/store/43zml0mlr17r5jsagxr00xxx91hz9lky-openpam-20170430/lib/libpam.so, 6): image not found
      # lib.systems.inspect.patterns.isDarwin
    ];
  };
})
