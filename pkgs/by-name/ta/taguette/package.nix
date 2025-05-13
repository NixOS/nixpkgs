{
  lib,
  stdenvNoCC,
  python3Packages,
  fetchFromGitLab,
  calibre,
  runtimeInputs ? [
    calibre
  ],
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "taguette";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "remram44";
    repo = "taguette";
    tag = "v${version}";
    hash = "sha256-QoVgc0jJBpJeUiWctFeNc5pBUdQ9sk6DrLERwg58vmE=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  pythonRelaxDeps = [
    "alembic"
    "bleach"
    "opentelemetry-api"
    "redis"
    "subtitle-parser"
  ];

  dependencies = with python3Packages; [
    (alembic.override { sqlalchemy = sqlalchemy_1_4; })
    beautifulsoup4
    bleach
    chardet
    html5lib
    jinja2
    opentelemetry-api
    prometheus-async
    prometheus-client
    redis
    sentry-sdk
    sqlalchemy_1_4
    subtitle-parser
    tornado
    xlsxwriter
  ];

  optional-dependencies = with python3Packages; {
    mysql = [
      cryptography
      pymysql
    ];
    otel = [
      opentelemetry-distro
      opentelemetry-instrumentation-sqlalchemy
      opentelemetry-instrumentation-tornado
    ];
    postgres = [
      psycopg2
    ];
  };

  # Calibre is needed to convert documents. While it is available on MacOS, it
  # is only available on Linux via Nix. Therefore, making this as conditional
  # so that users on MacOS are not blocked by this.
  postFixup = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    wrapProgram $out/bin/taguette \
      --suffix PATH : ${lib.makeBinPath runtimeInputs}
  '';

  pythonImportsCheck = [
    "taguette"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) taguette;
    };
  };

  meta = {
    description = "Free and open source qualitative research tool";
    homepage = "https://gitlab.com/remram44/taguette";
    changelog = "https://gitlab.com/remram44/taguette/-/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "taguette";
  };
}
