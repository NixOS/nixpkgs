{
  lib,
  python3,
  fetchFromGitHub,
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
  version = "3.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "umap-project";
    repo = "umap";
    rev = version;
    hash = "sha256-u7XdthSXG2rJa9GOzpDBZxKu+reabKnfX5qrr8ZiI1c=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python.pkgs; [
    django
    django-agnocomplete
    django-environ
    django-probes
    pillow
    psycopg
    rcssmin
    requests
    rjsmin
    social-auth-app-django
    social-auth-core
  ];

  pythonRelaxDeps = [
    "django"
    "social-auth-core"
    "social-auth-app-django"
  ];

  #  optional-dependencies = with python3.pkgs; {
  #    dev = [
  #      djlint
  #      hatch
  #      isort
  #      mkdocs
  #      mkdocs-material
  #      mkdocs-static-i18n
  #      pymdown-extensions
  #      ruff
  #      vermin
  #    ];
  #    docker = [
  #      uvicorn
  #    ];
  #    s3 = [
  #      django-storages
  #    ];
  #    sync = [
  #      pydantic
  #      redis
  #      websockets
  #    ];
  #    test = [
  #      daphne
  #      factory-boy
  #      moto
  #      playwright
  #      pytest
  #      pytest-django
  #      pytest-playwright
  #      pytest-rerunfailures
  #      pytest-xdist
  #    ];
  #  };

  meta = {
    description = "UMap lets you create maps with OpenStreetMap layers in a minute and embed them in your site";
    homepage = "https://github.com/umap-project/umap/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ LorenzBischof ];
    mainProgram = "umap";
  };
}
