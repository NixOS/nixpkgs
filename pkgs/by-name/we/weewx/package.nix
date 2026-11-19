{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  glibcLocales,
  tzdata,
  testers,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "weewx";
  version = "5.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "weewx";
    repo = "weewx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XqcxXGrw9Z4/xtz8QIA2l2gwwH1L/UcH6ZBNvifhvx0=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    configobj
    ct3
    pillow
    ephem
    pymysql
    pyserial
    pyusb
  ];

  postInstall = ''
    install -Dm644 src/weewx_data/util/udev/rules.d/weewx.rules \
      $out/lib/udev/rules.d/60-weewx.rules
    install -Dm644 src/weewx_data/util/bash_completion.d/weectl \
      $out/share/bash-completion/completions/weectl
  '';

  # Upstream PRs #1212, #1213, #1214, #1215 merged in master:
  # - /var/tmp is replaced with tempfile.gettempdir()
  # - MySQL tests cleanly skip when WEEWX_TEST_MYSQL=0
  # - Locale mutations are isolated via fixtures
  # - pytest import-mode and pythonpath are configured in pyproject.toml
  env = {
    TZDIR = "${tzdata}/share/zoneinfo";
    WEEWX_TEST_MYSQL = "0";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
  };

  nativeCheckInputs =
    with python3Packages;
    [
      pytestCheckHook
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux glibcLocales;

  disabledTests = [
    # Requires network access
    "test_http_install"
    # Requires de_DE.UTF-8 locale in glibc archive
    "test_report_engine"
  ];

  pythonImportsCheck = [
    "weewx"
    "weectllib"
    "weeutil"
    "weeplot"
    "weedb"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Weather station data logger and report generator";
    homepage = "https://weewx.com";
    changelog = "https://github.com/weewx/weewx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "weectl";
    maintainers = with lib.maintainers; [ xela-zone ];
  };
})
