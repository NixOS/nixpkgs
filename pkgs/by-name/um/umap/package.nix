{
  lib,
  python3,
  fetchFromGitHub,
  writeShellScript,
  makeWrapper,
  umap,
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
python.pkgs.buildPythonApplication rec {
  pname = "umap";
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "umap-project";
    repo = "umap";
    rev = version;
    hash = "sha256-6izKVZWXlP7yk1vvDDeaSNnzlWCF1xLLUyELaeTngN0=";
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
    pythonPath = "${umap}/${python.sitePackages}:${python.pkgs.makePythonPath dependencies}";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall =
    let
      start_script = writeShellScript "umap-serve" ''
        ${lib.getExe python3.pkgs.uvicorn} "$@" umap.asgi:application;
      '';
    in
    ''
      makeWrapper ${start_script} $out/bin/umap-serve \
        --prefix PYTHONPATH : "$out/${python.sitePackages}" \
        --prefix PYTHONPATH : "${python.pkgs.makePythonPath dependencies}";
    '';

  nativeCheckInputs =
    with python.pkgs;
    [
      pytest
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
    # The proxy_request tests require network
    "proxy_request_with"
    "test_good_request_passes"
    "test_valid_proxy_request"
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
}
