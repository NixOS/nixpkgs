{
  lib,
  python3,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs,
  pkg-config,
  faketty,
  vips,
}:
let
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "wizarrrr";
    repo = "wizarr";
    rev = "refs/tags/v4.1.1";
    hash = "sha256-a5rqrN5wxK7YwO4vsJg9KJx9LckF/g5Z0YGf1K05/Ns=";
  };
in
python3.pkgs.buildPythonApplication {
  pname = "wizarr";
  inherit version src;
  pyproject = true;

  sourceRoot = "${src.name}/apps/wizarr-backend";

  # Remove arbitrary limitation of the server only being accessible via 127.0.0.1:5000
  postPatch = ''
    sed -i '/"127.0.0.1:5000"$/d' wizarr_backend/app/config.py
  '';

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
    wrapPython
  ];

  build-system = with python3.pkgs; [
    poetry-core
  ];

  dependencies = with python3.pkgs; [
    apscheduler
    coloredlogs
    cryptography
    python-dotenv
    flask
    flask-caching
    flask-jwt-extended
    flask-restx
    flask-session
    flask-socketio
    python-nmap
    packaging
    peewee
    plexapi
    psutil
    pytz
    requests
    schematics
    tabulate
    termcolor
    webauthn
    werkzeug
    sentry-sdk
    gunicorn
    gevent
    gevent-websocket
    pydantic
    requests-cache
    flask-apscheduler
    password-strength
  ];

  # Needs to be added to the PYTHONPATH for gunicorn
  propagatedBuildInputs = with python3.pkgs; [ gevent-websocket ];

  pythonRemoveDeps = [
    # Unmaintained and unused
    "flask-oauthlib"
  ];

  pythonRelaxDeps = [
    "cryptography"
    "flask"
    "flask-session"
    "gevent"
    "gunicorn"
    "packaging"
    "psutil"
    "pydantic"
    "pytz"
    "webauthn"
    "password-strength"
  ];

  postInstall = ''
    install -Dm644 ${src}/latest -t $out/share/wizarr

    # The backend scripts expect modules like app, api, etc. to be on the *top-level* instead of
    # being under wizarr_backend. (i.e. imports look like `from app` instead of `from wizarr_backend.app`).
    # Instead of patching every file, we just move them out to be directly underneath site packages.
    (cd $out/${python3.sitePackages}; mv wizarr_backend/* .)
  '';

  # Test points at nonexistent module
  doCheck = false;

  postFixup = ''
    mkdir -p $out/bin

    makeWrapper ${lib.getExe python3.pkgs.gunicorn} $out/bin/wizarr \
      --prefix PATH : "$program_PATH" \
      --set PYTHONPATH "$program_PYTHONPATH" \
      --set LATEST_FILE "$out/share/wizarr/latest" \
      --add-flags "-k geventwebsocket.gunicorn.workers.GeventWebSocketWorker" \
      --add-flags "-m 007 run:app"
  '';

  pythonImportsCheck = [ "wizarr_backend" ];

  passthru.frontend = buildNpmPackage {
    pname = "wizarr-frontend";
    inherit version src;

    npmDepsHash = "sha256-IV/xzBrgisbMRCE1cDNoBjRAbHq3Wz2D1UFQl0EPbW0=";

    makeCacheWritable = true;

    nativeBuildInputs = [
      nodejs
      pkg-config
      faketty
    ];

    buildInputs = [ vips ];

    # Avoid running postinstall which calls `nx run wizarr-backend:install`
    npmFlags = [ "--ignore-script" ];

    env.CYPRESS_INSTALL_BINARY = "0";

    buildPhase = ''
      runHook preBuild
      faketty npm run build -w @wizarrrr/wizarr-frontend
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r dist/apps/wizarr-frontend $out
      runHook postInstall
    '';
  };

  meta = {
    description = "Advanced user invitation and management system for Jellyfin, Plex, Emby etc.";
    homepage = "https://wizarr.dev/";
    changelog = "https://github.com/wizarrrr/wizarr/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    mainProgram = "wizarr";
  };
}
