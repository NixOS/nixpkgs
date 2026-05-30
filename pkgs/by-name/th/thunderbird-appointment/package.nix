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
    packageOverrides = final: prev: {
      niquests = prev.niquests.overridePythonAttrs (old: {
        # These live SSL/network tests are unrelated to Appointment itself.
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
in
pythonPackages.buildPythonApplication (
  finalAttrs:
  let
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

    runtimeDependencies = with pythonPackages; [
      alembic
      argon2-cffi
      authlib
      babel
      caldav
      celery
      celery-redbeat-pypi
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
      icalendar
      itsdangerous
      jinja2
      markdown
      nh3
      niquests
      oauthlib
      posthog
      psycopg
      pydantic
      pyjwt
      python-dotenv
      python-multipart
      redis
      requests-oauthlib
      sentry-sdk
      slowapi
      sqlalchemy
      sqlalchemy-utils
      starlette-context
      starlette-csrf
      typer
      tzdata
      uvicorn
      validators
    ];
  in
  {
    pname = "thunderbird-appointment";
    __structuredAttrs = true;

    inherit version src;

    sourceRoot = "source/backend";

    postPatch = ''
      cat >> pyproject.toml <<'EOF'

      [tool.setuptools]
      include-package-data = true

      [tool.setuptools.package-data]
      appointment = [
        "l10n/*/*.ftl",
        "templates/assets/img/*.png",
        "templates/assets/img/icons/*.png",
        "templates/email/*.jinja2",
        "templates/email/errors/*.jinja2",
        "templates/email/includes/*.jinja2",
      ]
      EOF
    '';

    pyproject = true;

    build-system = [ pythonPackages.setuptools ];

    dependencies = runtimeDependencies;

    nativeBuildInputs = [ makeWrapper ];

    # Upstream ships a tightly pinned requirements.txt for container builds.
    # Relax it! Now the runtime dependency check accepts the
    # compatible nixpkgs versions.
    pythonRelaxDeps = true;

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

    # These tests depend on live public DNS state
    disabledTests = [
      "test_for_host"
      "test_for_txt_record"
      "test_no_records"
    ];

    preCheck = ''
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
        cli.executable = lib.getExe' finalAttrs.finalPackage "thunderbird-appointment-cli";
        api.executable = lib.getExe' finalAttrs.finalPackage "thunderbird-appointment-api";
        worker.executable = lib.getExe' finalAttrs.finalPackage "thunderbird-appointment-worker";
        flower.executable = lib.getExe' finalAttrs.finalPackage "thunderbird-appointment-flower";
      };

      tests = {
        frontendBuild = frontend.passthru.tests.build;

        serviceSmoke =
          runCommand "${finalAttrs.pname}-service-smoke"
            {
              nativeBuildInputs = [ finalAttrs.finalPackage ];
            }
            ''
              test -f ${finalAttrs.finalPackage}/share/thunderbird-appointment/frontend/index.html

              thunderbird-appointment-cli --help > /dev/null
              thunderbird-appointment-api --help > /dev/null
              thunderbird-appointment-worker --help > /dev/null
              thunderbird-appointment-flower --help > /dev/null

              export PYTHONPATH="${finalAttrs.finalPackage}/${python.sitePackages}:${pythonPackages.makePythonPath runtimeDependencies}"
              ${python.interpreter} - <<'PY'
              import appointment.celery_app
              import appointment.main
              import redbeat
              PY

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
      maintainers = with lib.maintainers; [ philocalyst ];
      platforms = platforms.unix;
      mainProgram = "thunderbird-appointment-api";
    };
  }
)
