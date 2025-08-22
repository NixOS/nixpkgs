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

  # disable broken pinning test
  preCheck = ''
    substituteInPlace cachalot/tests/read.py \
      --replace-fail \
        "def test_explain(" \
        "def _test_explain("
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "No effort, no worry, maximum performance";
    homepage = "https://github.com/noripyt/django-cachalot";
    changelog = "https://github.com/noripyt/django-cachalot/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
