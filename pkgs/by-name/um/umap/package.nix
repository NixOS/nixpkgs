{
  lib,
  python3,
  fetchFromGitHub,
  umap,
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
  version = "3.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "umap-project";
    repo = "umap";
    rev = version;
    hash = "sha256-3TYqPIY4qzg/EZoblZ3VcXwjdC8aGbAa76gVkgXkrPE=";
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
  ];

  postInstall = ''
    export STATIC_ROOT=$out/static
    mkdir -p $STATIC_ROOT
    python3 manage.py collectstatic --noinput
  '';
  makeWrapperArgs = [
    "--set STATIC_ROOT ${placeholder "out"}/static"
  ];

  passthru = {
    pythonPath = "${umap}/${python.sitePackages}:${python.pkgs.makePythonPath dependencies}";
  };

  meta = {
    description = "UMap lets you create maps with OpenStreetMap layers in a minute and embed them in your site";
    homepage = "https://github.com/umap-project/umap/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      LorenzBischof
      jcollie
    ];
    mainProgram = "umap";
  };
}
