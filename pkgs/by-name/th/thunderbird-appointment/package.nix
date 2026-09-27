{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs_22,
  python3,
  makeWrapper,
  nixosTests,
  runCommand,
}:

let
  pythonPackages = python3.pkgs;

in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "thunderbird-appointment";
  __structuredAttrs = true;

  version = "1.4.2";
  src = fetchFromGitHub {
    owner = "thunderbird";
    repo = "appointment";
    rev = "r-0837";
    hash = "sha256-SilLfP/Vvbk91j1DekKXoNbD61/t0crl8ZubVBzbADE=";
  };

  sourceRoot = "source/backend";

  postPatch = ''
    cat > pyproject.toml << 'TOML'
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
    TOML
  '';

  pyproject = true;

  build-system = [ pythonPackages.setuptools ];

  dependencies = with pythonPackages; [
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
          --prefix PYTHONPATH : "$out/${python3.sitePackages}" \
          --add-flags "${args}"
      '';
    in
    ''
      mkdir -p $out/share/thunderbird-appointment/frontend
      cp -r ${finalAttrs.passthru.frontend}/dist/. $out/share/thunderbird-appointment/frontend/

      ln -s run-command $out/bin/thunderbird-appointment-cli

      # Bind to loopback by default; the NixOS module fronts it with nginx.
      ${wrap "api" "uvicorn" "--factory appointment.main:server --host 127.0.0.1 --port 5000"}
      ${wrap "worker" "celery" "-A appointment.celery_app:celery worker -l INFO --beat -Q appointment"}
      ${wrap "flower" "celery" "-A appointment.celery_app:celery flower -l INFO --address=127.0.0.1"}
    '';

  passthru = {
    frontend = buildNpmPackage (frontendAttrs: {
      pname = "thunderbird-appointment-frontend";
      nodejs = nodejs_22;

      inherit (finalAttrs) version src;

      sourceRoot = "source/frontend";
      npmDepsHash = "sha256-xsifpdFtDJx3eW5kXw4Bg4udXxyySuX8cLgH+rK3WLo=";

      env.TZ = "America/Vancouver";

      preBuild = ''
        npm run lint
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
            ${lib.concatMapStringsSep "\n" (b: "thunderbird-appointment-${b} --help > /dev/null") bins}
            export PYTHONPATH="${finalAttrs.finalPackage}/${python3.sitePackages}:${pythonPackages.makePythonPath finalAttrs.dep}"
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
    changelog = "https://github.com/thunderbird/appointment/releases/tag/r-0837";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.unix;
    mainProgram = "thunderbird-appointment-api";
  };
})
