{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  python3,
  makeWrapper,
  nixosTests,
}:

let
  version = "1.4.1";
  src = fetchFromGitHub {
    owner = "thunderbird";
    repo = "appointment";
    rev = "r-0825";
    hash = "sha256-hgZuokYobQP57dBbIvtaH2ynaMl8h3pc9vIoDgGs0uI=";
  };

  frontend = buildNpmPackage {
    pname = "thunderbird-appointment-frontend";
    inherit version src;
    sourceRoot = "source/frontend";
    npmDepsHash = "sha256-TmhsLwMbGpBW7QXfIHc3cemD/L8fWh97yOZSLvj2YY4=";
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist $out/
      runHook postInstall
    '';
  };
in
python3.pkgs.buildPythonApplication {

  pname = "thunderbird-appointment";
  inherit version src;

  sourceRoot = "source/backend";

  postPatch = ''
    substituteInPlace src/appointment/main.py \
      --replace-fail 'from starlette_csrf import CSRFMiddleware' 'from asgi_csrf import CSRFMiddleware'
  '';

  pyproject = true;

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    alembic
    argon2-cffi
    babel
    niquests
    caldav
    celery

    celery-redbeat
    cryptography
    dnspython
    fastapi
    flower
    fluent-runtime
    fluent-syntax
    google-api-python-client
    google-auth-httplib2
    google-auth-oauthlib
    hiredis
    jinja2
    icalendar
    itsdangerous
    markdown
    nh3
    oauthlib
    posthog
    psycopg
    python-dotenv
    python-multipart
    pyjwt
    pydantic
    requests-oauthlib
    redis
    sentry-sdk
    slowapi
    starlette-context
    asgi-csrf
    sqlalchemy
    sqlalchemy-utils
    typer
    tzdata
    uvicorn
    validators
    authlib
  ];

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    faker
    httpx
    freezegun
    coverage
    ruff
  ];

  pythonImportsCheck = [ "appointment" ];

  env = {
    APP_SECRET_KEY = "test-key-for-tests";
    DB_URL = "sqlite:///:memory:";
    APP_ALLOW_FIRST_TIME_REGISTER = "true";
  };

  postInstall = ''
    mkdir -p $out/share/thunderbird-appointment/frontend
    cp -r ${frontend}/* $out/share/thunderbird-appointment/frontend/

    makeWrapper ${python3.interpreter} $out/bin/run-command \
      --prefix PYTHONPATH : "$out/${python3.sitePackages}" \
      --add-flags "-m appointment.main"
  '';

  passthru.tests = {
    inherit (nixosTests) thunderbird-appointment;
  };

  meta = with lib; {
    description = "Thunderbird Appointment - Invite others to grab times on your calendar";
    homepage = "https://github.com/thunderbird/appointment";
    license = licenses.mpl20;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "run-command";
  };
}
