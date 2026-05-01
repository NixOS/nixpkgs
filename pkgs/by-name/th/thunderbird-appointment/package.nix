{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs_20,
  python3,
  makeWrapper,
  nixosTests,
  runCommand,
}:

let
  python = python3.override {
    self = python;
    packageOverrides =
      final: prev: {
        niquests = prev.niquests.overridePythonAttrs (old: {
          # These live SSL/network tests are unrelated to Appointment itself and
          # currently fail during local package verification on Darwin.
          disabledTestPaths = (old.disabledTestPaths or [ ]) ++ [
            "tests/test_live.py"
            "tests/test_sse.py"
          ];
        });
      };
  };
  pythonPackages = python.pkgs;

  version = "1.4.2";
  src = fetchFromGitHub {
    owner = "thunderbird";
    repo = "appointment";
    rev = "r-0837";
    hash = "sha256-SilLfP/Vvbk91j1DekKXoNbD61/t0crl8ZubVBzbADE=";
  };

  frontend = buildNpmPackage (frontendAttrs: {
    pname = "thunderbird-appointment-frontend";
    inherit version src;
    nodejs = nodejs_20;

    sourceRoot = "source/frontend";
    npmDepsHash = "sha256-xsifpdFtDJx3eW5kXw4Bg4udXxyySuX8cLgH+rK3WLo=";

    env.TZ = "America/Vancouver";

    preBuild = ''
      npm run lint
      npm run test -- --run
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist $out/
      runHook postInstall
    '';
    
    passthru.tests.build = runCommand "${frontendAttrs.pname}-build-test" { } ''
      test -f ${frontendAttrs.finalPackage}/dist/index.html
      test -d ${frontendAttrs.finalPackage}/dist/assets
      touch $out
    '';
  });
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "thunderbird-appointment";
  inherit version src;

  sourceRoot = "source/backend";

  postPatch = ''
    substituteInPlace src/appointment/main.py \
      --replace-fail 'from starlette_csrf import CSRFMiddleware' 'from asgi_csrf import CSRFMiddleware'
  '';

  pyproject = true;

  build-system = [ pythonPackages.setuptools ];

  # Keep this aligned with backend/requirements.txt. Extras that nixpkgs
  # packages separately are listed explicitly where they matter at runtime.
  dependencies = with pythonPackages; [
    alembic
    argon2-cffi
    babel
    niquests
    caldav
    celery
    celery-redbeat
    cryptography
    dnspython
    email-validator
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

  nativeCheckInputs = with pythonPackages; [
    pytestCheckHook
    faker
    httpx
    freezegun
    coverage
    ruff
  ];

  pythonImportsCheck = [ "appointment" ];

  pytestFlagsArray = [
    "--disable-warnings"
    "-s"
  ];

  preCheck = ''
    ruff format --check
    ruff check
  '';

  postInstall = ''
    mkdir -p $out/share/thunderbird-appointment/frontend
    cp -r ${frontend}/dist/. $out/share/thunderbird-appointment/frontend/

    ln -s run-command $out/bin/thunderbird-appointment-cli

    makeWrapper ${lib.getExe pythonPackages.uvicorn} $out/bin/thunderbird-appointment-api \
      --prefix PYTHONPATH : "$out/${python.sitePackages}" \
      --add-flags "--factory appointment.main:server --host 0.0.0.0 --port 5000"

    makeWrapper ${lib.getExe pythonPackages.celery} $out/bin/thunderbird-appointment-worker \
      --prefix PYTHONPATH : "$out/${python.sitePackages}" \
      --add-flags "-A appointment.celery_app:celery worker -l INFO --beat -Q appointment"

    makeWrapper ${lib.getExe pythonPackages.celery} $out/bin/thunderbird-appointment-flower \
      --prefix PYTHONPATH : "$out/${python.sitePackages}" \
      --add-flags "-A appointment.celery_app:celery flower -l INFO"
  '';

  passthru = {
    inherit frontend;
    frontendPath = "${finalAttrs.finalPackage}/share/thunderbird-appointment/frontend";

    services = {
      api.executable = lib.getExe' finalAttrs.finalPackage "thunderbird-appointment-api";
      worker.executable = lib.getExe' finalAttrs.finalPackage "thunderbird-appointment-worker";
      flower.executable = lib.getExe' finalAttrs.finalPackage "thunderbird-appointment-flower";
    };

    tests = {
      frontendBuild = frontend.passthru.tests.build;

      packageLayout = runCommand "${finalAttrs.pname}-package-layout" { } ''
        test -x ${lib.getExe' finalAttrs.finalPackage "run-command"}
        test -x ${lib.getExe' finalAttrs.finalPackage "thunderbird-appointment-api"}
        test -x ${lib.getExe' finalAttrs.finalPackage "thunderbird-appointment-worker"}
        test -x ${lib.getExe' finalAttrs.finalPackage "thunderbird-appointment-flower"}
        test -f ${finalAttrs.finalPackage}/share/thunderbird-appointment/frontend/index.html
        test -d ${finalAttrs.finalPackage}/share/thunderbird-appointment/frontend/assets
        touch $out
      '';

      cliHelp = runCommand "${finalAttrs.pname}-cli-help" {
        nativeBuildInputs = [ finalAttrs.finalPackage ];
      } ''
        run-command --help > /dev/null
        thunderbird-appointment-api --help > /dev/null
        thunderbird-appointment-worker --help > /dev/null
        thunderbird-appointment-flower --help > /dev/null
        touch $out
      '';

      inherit (nixosTests) thunderbird-appointment;
    };
  };

  meta = with lib; {
    description = "Thunderbird Appointment - Invite others to grab times on your calendar";
    homepage = "https://github.com/thunderbird/appointment";
    changelog = "https://github.com/thunderbird/appointment/releases/tag/r-0837";
    license = licenses.mpl20;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "thunderbird-appointment-api";
  };
})
