{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitLab,
  poetry-core,
  dramatiq,
  flask,
  requests,
  pytestCheckHook,
  pytest-cov-stub,
  flask-migrate,
  periodiq,
  postgresql,
  postgresqlTestHook,
  psycopg2,
}:

buildPythonPackage {
  pname = "flask-dramatiq";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitLab {
    owner = "bersace";
    repo = "flask-dramatiq";
    rev = "840209e9bf582b4dda468e8bba515f248f3f8534";
    hash = "sha256-qjV1zyVzHPXMt+oUeGBdP9XVlbcSz2MF9Zygj543T4w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'poetry>=0.12' 'poetry-core' \
      --replace 'poetry.masonry.api' 'poetry.core.masonry.api'

    patchShebangs --build ./example.py
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ dramatiq ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    flask
    requests
    flask-migrate
    periodiq
    postgresql
    postgresqlTestHook
    psycopg2
  ]
  ++ dramatiq.optional-dependencies.rabbitmq;

  postgresqlTestSetupPost = ''
    substituteInPlace config.py \
      --replace 'SQLALCHEMY_DATABASE_URI = f"postgresql://{PGUSER}:{PGPASSWORD}@{PGHOST}/{PGDATABASE}"' \
        "SQLALCHEMY_DATABASE_URI = \"postgresql://$PGUSER/$PGDATABASE?host=$PGHOST\""
    python3 ./example.py db upgrade
  '';

  pytestFlags = [
    "-x"
  ];

  disabledTestPaths = [
    "tests/func/"
    "tests/unit"
  ];

  pythonImportsCheck = [ "flask_dramatiq" ];

  # Does HTTP requests to localhost
  disabledTests = [
    "test_fast"
    "test_other"
  ];

  meta = with lib; {
    description = "Adds Dramatiq support to your Flask application";
    homepage = "https://gitlab.com/bersace/flask-dramatiq";
    license = licenses.bsd3;
    maintainers = with maintainers; [ traxys ];
  };
}
