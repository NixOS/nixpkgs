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
  version = "5.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "weewx";
    repo = "weewx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E6NCC0ALTtGUY+0vMZbt0jWLX8sRXTpFiUOWakiNFuk=";
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

  postPatch = ''
    # Upstream test files hardcode /var/tmp which does not exist in the sandbox
    # https://github.com/weewx/weewx/pull/1213
    for f in $(grep -rl "/var/tmp" src/*/test*); do
      substituteInPlace "$f" --replace-quiet "/var/tmp" "$TMPDIR"
    done

    # Remove MySQL fixtures from parameterized test suite
    # https://github.com/weewx/weewx/pull/1214
    substituteInPlace src/weewx/tests/conftest.py --replace-fail "'mysql'," ""

    # Upstream setlocale calls pollute global process state and break time formatting tests
    # https://github.com/weewx/weewx/pull/1212
    substituteInPlace src/weewx/tests/test_templates.py \
      --replace-fail "locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')" "pass"
    substituteInPlace src/weewx/tests/test_xtypes.py \
      --replace-fail "locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')" "pass"
  '';

  preCheck = ''
    export PYTHONPATH="src/weewx/tests:$PYTHONPATH"
  '';

  nativeCheckInputs =
    with python3Packages;
    [
      pytestCheckHook
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux glibcLocales;

  env = {
    TZDIR = "${tzdata}/share/zoneinfo";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
  };

  pytestFlags = [
    "--import-mode=importlib"
  ];
  disabledTestPaths = [
    # Skip weedb unit tests which require live MySQL/PostgreSQL daemons
    # https://github.com/weewx/weewx/pull/1214
    "src/weedb"
  ];

  disabledTests = [
    # Requires network access
    "test_http_install"
    # Requires a running MySQL database server
    "mysql"
    "MySQL"
    "archive_db_dict1"
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
