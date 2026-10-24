{
  lib,
  fetchFromGitHub,
  stdenv,
  fetchPnpmDeps,
  pnpm_11,
  pnpmConfigHook,
  nodejs_24,
  python3,
  makeWrapper,
  nixosTests,
  runCommand,
  writeText,
}:

let
  pythonPackages = python3.pkgs;
  version = "1.9.1";
  runtimeDependencies = with pythonPackages; [
    alembic
    argon2-cffi
    authlib
    babel
    (caldav.overridePythonAttrs (old: {
      disabledTestPaths = (old.disabledTestPaths or [ ]) ++ [
        "tests/test_caldav.py::test_get_davclient_returns_none_without_env_or_config"
      ];
    }))
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

  backendPyproject = writeText "thunderbird-appointment-pyproject.toml" ''
    [project]
    name = "thunderbird-appointment"
    version = "${version}"

    [project.scripts]
    run-command = "appointment.main:cli"

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
  '';

in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "thunderbird-appointment";
  inherit version;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "thunderbird";
    repo = "appointment";
    rev = "r-0942";
    hash = "sha256-o6dUQLHtNmliSOBp/gf46uez4aZT/jrCWmfobpK//b8=";
  };

  sourceRoot = "source/backend";

  postPatch = ''
    cp ${backendPyproject} pyproject.toml

    # Resolve Schedule's CalendarBase forward reference before tests freeze
    # time. Freezegun patches the module-level `date` name, which breaks
    # Pydantic's lazy rebuild of this model on the first request in that scope.
    python3 - <<'PY'
    from pathlib import Path

    path = Path("src/appointment/database/schemas.py")
    source = path.read_text()
    marker = "class CalendarBase(BaseModel):\n"
    end = "\n\nclass CalendarConnectionOut("
    if source.count(marker) != 1 or source.count(end) != 1:
        raise SystemExit("unexpected Appointment schema layout")
    start = source.index(marker)
    insertion = source.index(end, start)
    if "Schedule.model_rebuild()" in source:
        raise SystemExit("Schedule schema rebuild already present")
    source = source[:insertion] + "\n\n# Resolve Schedule's CalendarBase forward reference eagerly.\nSchedule.model_rebuild()" + source[insertion:]
    path.write_text(source)
    PY
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

  pytestFlags = [
    "--disable-warnings"
    "-s"
  ];

  # Upstream conftest imports `defines` from backend/test as a top-level module.
  preCheck = ''
    export PYTHONPATH="$PWD/test''${PYTHONPATH:+:$PYTHONPATH}"
  '';

  # These tests depend on live public DNS state
  disabledTests = [
    "test_for_host"
    "test_for_txt_record"
    "test_no_records"
  ];

  postInstall =
    let
      wrap = name: pkg: args: ''
        makeWrapper ${lib.getExe pythonPackages.${pkg}} $out/bin/thunderbird-appointment-${name} \
          --prefix PYTHONPATH : "$out/${python3.sitePackages}:${pythonPackages.makePythonPath runtimeDependencies}" \
          --add-flags "${args}"
      '';
    in
    ''
      mkdir -p $out/share/thunderbird-appointment/frontend
      cp -r ${finalAttrs.passthru.frontend}/dist/. $out/share/thunderbird-appointment/frontend/
      mkdir -p $out/share/thunderbird-appointment
      cp ${finalAttrs.src}/backend/alembic.ini.example $out/share/thunderbird-appointment/alembic.ini
      ln -s "../../${python3.sitePackages}/appointment" $out/share/thunderbird-appointment/appointment

      ln -s run-command $out/bin/thunderbird-appointment-cli

      # Bind to loopback by default; the NixOS module fronts it with nginx.
      ${wrap "api" "uvicorn" "--factory appointment.main:server --host 127.0.0.1 --port 5000"}
      ${wrap "worker" "celery" "-A appointment.celery_app:celery worker -l INFO --beat -Q appointment"}
      ${wrap "flower" "celery" "-A appointment.celery_app:celery flower -l INFO --address=127.0.0.1"}
    '';

  passthru = {
    frontend = stdenv.mkDerivation (frontendAttrs: {
      pname = "thunderbird-appointment-frontend";
      inherit (finalAttrs) version src;

      sourceRoot = "source/frontend";

      pnpmDeps = fetchPnpmDeps {
        inherit (frontendAttrs) pname version src;
        sourceRoot = "${frontendAttrs.src.name}/frontend";
        pnpm = pnpm_11;
        fetcherVersion = 4;
        hash = "sha256-Jw/dxpnnnpKeP13UcEHORtSVbJ5Ez2pbFtZLcrV/b74=";
      };

      nativeBuildInputs = [
        nodejs_24
        pnpm_11
        pnpmConfigHook
      ];

      buildInputs = [ frontendAttrs.pnpmDeps ];

      env.TZ = "America/Vancouver";

      buildPhase = ''
        runHook preBuild
        pnpm run lint
        pnpm run build
        runHook postBuild
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

    frontendPath = "${finalAttrs.finalPackage}/share/thunderbird-appointment/frontend";

    services = {
      api.executable = lib.getExe finalAttrs.finalPackage;
      cli.executable = lib.getExe' finalAttrs.finalPackage "thunderbird-appointment-cli";
      worker.executable = lib.getExe' finalAttrs.finalPackage "thunderbird-appointment-worker";
      flower.executable = lib.getExe' finalAttrs.finalPackage "thunderbird-appointment-flower";
    };

    tests = {
      frontendBuild = finalAttrs.passthru.frontend.passthru.tests.build;

      serviceSmoke =
        let
          bins = [
            "cli"
            "api"
            "worker"
            "flower"
          ];
        in
        runCommand "${finalAttrs.pname}-service-smoke" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
          ''
            test -f ${finalAttrs.finalPackage}/share/thunderbird-appointment/frontend/index.html
            test -f ${finalAttrs.finalPackage}/share/thunderbird-appointment/alembic.ini
            test -f ${finalAttrs.finalPackage}/share/thunderbird-appointment/appointment/migrations/env.py
            ${lib.concatMapStringsSep "\n" (b: "thunderbird-appointment-${b} --help > /dev/null") bins}
            export PYTHONPATH="${finalAttrs.finalPackage}/${python3.sitePackages}:${pythonPackages.makePythonPath runtimeDependencies}"
            ${python3.interpreter} - <<'PY'
            import appointment.celery_app
            import appointment.main
            import redbeat
            PY
            touch $out
          '';

      inherit (nixosTests) thunderbird-appointment;
    };
  };

  meta = {
    description = "Thunderbird Appointment - Invite others to grab times on your calendar";
    homepage = "https://github.com/thunderbird/appointment";
    changelog = "https://github.com/thunderbird/appointment/releases/tag/r-0942";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.unix;
    mainProgram = "thunderbird-appointment-api";
  };
})
