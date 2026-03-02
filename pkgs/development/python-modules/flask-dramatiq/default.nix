{
  lib,
  buildPythonPackage,
  dramatiq,
  fetchFromGitHub,
  flask-migrate,
  flask-sqlalchemy,
  flask,
  httpx,
  periodiq,
  hatchling,
  postgresql,
  postgresqlTestHook,
  psycopg2,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "flask-dramatiq";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-dramatiq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gt9yynbmFWMISP1U0jRjU6oY3ImrLxYa2D0xf0llCEg=";
  };

  postPatch = ''
    patchShebangs --build ./example.py
  '';

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "dramatiq" ];

  dependencies = [ dramatiq ];

  nativeCheckInputs = [
    flask-sqlalchemy
    flask
    flask-migrate
    httpx
    periodiq
    postgresql
    postgresqlTestHook
    psycopg2
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    requests
  ]
  ++ dramatiq.optional-dependencies.rabbitmq
  ++ dramatiq.optional-dependencies.watch;

  postgresqlTestSetupPost = ''
    substituteInPlace config.py \
      --replace 'SQLALCHEMY_DATABASE_URI = f"postgresql://{PGUSER}:{PGPASSWORD}@{PGHOST}/{PGDATABASE}"' \
        "SQLALCHEMY_DATABASE_URI = \"postgresql://$PGUSER/$PGDATABASE?host=$PGHOST\""
    python3 ./example.py db upgrade
  '';

  disabledTests = [
    "test_fast"
    "test_other"
  ];

  pythonImportsCheck = [ "flask_dramatiq" ];

  meta = {
    description = "Adds Dramatiq support to your Flask application";
    homepage = "https://gitlab.com/bersace/flask-dramatiq";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ traxys ];
  };
})
