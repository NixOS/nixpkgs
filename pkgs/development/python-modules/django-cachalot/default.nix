{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  django-debug-toolbar,
  psycopg2,
  jinja2,
  beautifulsoup4,
  pytest-django,
  pytestCheckHook,
  python,
  pytz,
  redis,
  redisTestHook,
  setuptools,
  stdenv,
}:

buildPythonPackage rec {
  pname = "django-cachalot";
  version = "2.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "noripyt";
    repo = "django-cachalot";
    tag = "v${version}";
    hash = "sha256-3W+9cULL3mMtAkxbqetoIj2FL/HRbzWHIDMe9O1e6BM=";
  };

  patches = [
    # Disable tests for unsupported caching and database types which would
    # require additional running backends
    ./disable-unsupported-tests.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    beautifulsoup4
    django-debug-toolbar
    psycopg2
    jinja2
    pytest-django
    pytestCheckHook
    pytz
    redis
    redisTestHook
  ];

  pythonImportsCheck = [ "cachalot" ];

  # redisTestHook does not work on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=settings
  '';

  pytestFlags = [
    "-o python_files=*.py"
    "-o collect_imported_tests=false"
    "cachalot/tests"
    "cachalot/admin_tests"
  ];

  disabledTests = [
    # relies on specific EXPLAIN output format from sqlite, which is not stable
    "test_explain"
    # broken on django-debug-toolbar 6.0
    "test_rendering"
  ];

  meta = with lib; {
    description = "No effort, no worry, maximum performance";
    homepage = "https://github.com/noripyt/django-cachalot";
    changelog = "https://github.com/noripyt/django-cachalot/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
