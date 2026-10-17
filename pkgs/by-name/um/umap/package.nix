{
  lib,
  python3,
  fetchFromGitHub,
  writeShellScript,
  makeWrapper,
  postgresql,
  postgresqlTestHook,
  playwright-driver,
}:
let
  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
      django = prev.django_5.override { withGdal = true; };
    };
  };

in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "umap";
  version = "3.8.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "umap-project";
    repo = "umap";
    tag = finalAttrs.version;
    hash = "sha256-uhWa8CqNjqUAaPALWq6YiOFHahNmw4AVQWhAyfs18CU=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies =
    with python.pkgs;
    [
      django
      django-agnocomplete
      django-environ
      django-probes
      django-storages
      httpx
      pillow
      psycopg
      pydantic
      pydantic-core
      rcssmin
      redis
      requests
      rjsmin
      six
      social-auth-app-django
      social-auth-core
      websockets
      uvicorn
    ]
    ++ django-storages.optional-dependencies.s3;

  pythonRelaxDeps = [
    "django"
    "requests"
    "social-auth-core"
    "social-auth-app-django"
    "psycopg"
    "rcssmin"
    "rjsmin"
    "pillow"
  ];

  passthru = {
    pythonPath = "${finalAttrs.finalPackage}/${python.sitePackages}:${python.pkgs.makePythonPath finalAttrs.passthru.dependencies}";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall =
    let
      pythonPath = python.pkgs.makePythonPath finalAttrs.passthru.dependencies;
      start_script = writeShellScript "umap-serve" ''
        ${lib.getExe python3.pkgs.uvicorn} "$@" umap.asgi:application;
      '';
    in
    ''
      makeWrapper ${start_script} $out/bin/umap-serve \
        --prefix PYTHONPATH : "$out/${python.sitePackages}" \
        --prefix PYTHONPATH : "${pythonPath}"
    '';

  nativeCheckInputs =
    with python.pkgs;
    [
      pytest
      pytest-asyncio
      pytest-django
      pytest-playwright
      pytest-xdist
      pytest-rerunfailures
      moto
      factory-boy
      daphne
      pytestCheckHook
    ]
    ++ [
      (postgresql.withPackages (p: [ p.postgis ]))
      postgresqlTestHook
    ];

  preCheck = ''
    export UMAP_SETTINGS=umap/tests/settings.py
    export PLAYWRIGHT_BROWSERS_PATH=${playwright-driver.browsers}
    export DATABASE_URL="" # Defaults to localhost:5432 instead of respecting PGHOST
    export postgresqlTestUserOptions="LOGIN SUPERUSER" # Allow creation of databases
  '';

  disabledTestPaths = [
    # TODO: fix the failing tests
    "umap/tests/integration"
  ];

  disabledTests = [
    # Needs network: umap.utils.validate_url resolves the target hostname to
    # reject private IPs, so every AjaxProxy test fails DNS in the sandbox.
    "proxy_request_with"
    "test_valid_proxy_request"
    "test_invalid_ttl_is_coerced_to_default"
    "test_proxy_caches_response"
    "test_proxy_clears_stale_semaphore"
    "test_proxy_does_not_cache_upstream_error"
    "test_proxy_falls_back_when_no_content_type"
    "test_proxy_fast_path_ignores_held_semaphore"
    "test_proxy_long_url_does_not_exceed_filename_limit"
    "test_proxy_long_urls_with_common_prefix_do_not_collide"
    "test_proxy_sets_nosniff"
    "test_proxy_tolerates_raw_spaces_in_url"
    # Needs network: fetches a real URL
    "test_good_request_passes"
  ];

  meta = {
    description = "UMap lets you create maps with OpenStreetMap layers in a minute and embed them in your site";
    homepage = "https://github.com/umap-project/umap/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      LorenzBischof
      jcollie
    ];
    teams = with lib.teams; [
      geospatial
      ngi
    ];
    mainProgram = "umap";
  };
})
