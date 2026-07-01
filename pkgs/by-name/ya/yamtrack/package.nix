{
  lib,
  stdenvNoCC,
  python3,
  fetchFromGitHub,
  makeWrapper,
  nixosTests,
}:
let
  python = python3.withPackages (
    ps:
    with ps;
    [
      # https://github.com/FuzzyGrim/Yamtrack/blob/v0.25.1/requirements.txt
      aiohttp
      apprise
      beautifulsoup4
      celery
      croniter
      defusedxml
      django
      django-allauth
      django-celery-beat
      django-celery-results
      django-debug-toolbar
      django-health-check
      django-model-utils
      django-redis
      django-select2
      django-simple-history
      django-widget-tweaks
      gunicorn
      icalendar
      pillow
      psycopg
      python-decouple
      redis
      requests
      requests-ratelimiter
      unidecode
    ]
    ++ django-allauth.optional-dependencies.socialaccount
    ++ django-health-check.optional-dependencies.celery
    ++ django-health-check.optional-dependencies.redis
    ++ psycopg.optional-dependencies.c
    ++ psycopg.optional-dependencies.pool
    ++ redis.optional-dependencies.hiredis
  );
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "yamtrack";
  version = "0.25.3";
  src = fetchFromGitHub {
    owner = "FuzzyGrim";
    repo = "Yamtrack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6XuV0+2Metrxngkhhbx10Km6s0zWYT0ilrLAwTC7j3c=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    python
    makeWrapper
  ];
  buildInputs = [ python ];

  postPatch = ''
    # Yamtrack assumes the database file location (if sqlite is used) is relative to the application.
    # Since this is located in the read-only nix store, allow setting it via an environment variable.
    substituteInPlace src/config/settings.py \
      --replace-fail 'BASE_DIR / "db" / "db.sqlite3"' 'config("DB_FILE")'
    # Yamtrack doesn't allow configuring the port, which is fine in a docker container but problematic outside.
    substituteInPlace src/config/gunicorn.py \
      --replace-fail 'bind = "localhost:8001"' $'import decouple\nbind = "localhost:" + decouple.config("PORT", default="8001")'
  '';

  buildPhase = ''
    runHook preBuild

    cd src
    DB_FILE="" python manage.py collectstatic --noinput

    runHook postBuild
  '';

  installPhase =
    let
      makeWrapper = name: executable: args: ''
        makeWrapper ${executable} $out/bin/${name} \
          --chdir $out/lib/yamtrack \
          --set-default VERSION "v${finalAttrs.version} (nixpkgs)" \
          --add-flags "${args}"
      '';
    in
    ''
      runHook preInstall

      mkdir -p $out/lib
      cp -r . $out/lib/yamtrack

      mkdir -p $out/bin
      ln -s $out/lib/yamtrack/manage.py $out/bin/yamtrack-manage

      ${makeWrapper "yamtrack-migrate" python.interpreter "manage.py migrate --noinput"}
      ${makeWrapper "yamtrack" (lib.getExe' python "gunicorn")
        "--config python:config.gunicorn config.wsgi:application"
      }
      ${makeWrapper "yamtrack-celery" (lib.getExe' python "celery")
        "--app config worker --without-mingle --without-gossip"
      }
      ${makeWrapper "yamtrack-celery-beat" (lib.getExe' python "celery") "--app config beat"}

      runHook postInstall
    '';

  passthru = {
    tests = {
      inherit (nixosTests) yamtrack;
    };
    inherit python;
    staticFiles = "${finalAttrs.finalPackage}/lib/yamtrack/staticfiles";
  };

  meta = {
    description = "Self hosted media tracker";
    mainProgram = "yamtrack";
    homepage = "https://github.com/FuzzyGrim/Yamtrack";
    changelog = "https://github.com/FuzzyGrim/Yamtrack/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ agpl3Only ];
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
})
