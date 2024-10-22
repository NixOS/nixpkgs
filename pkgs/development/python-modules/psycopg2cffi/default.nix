{
  buildPythonPackage,
  cffi,
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlTestHook,
  pytestCheckHook,
  setuptools,
  six,
  stdenv,
}:

buildPythonPackage rec {
  pname = "psycopg2cffi";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chtd";
    repo = "psycopg2cffi";
    rev = "refs/tags/${version}";
    hash = "sha256-9r5MYxw9cvdbLVj8StmMmn0AKQepOpCc7TIBGXZGWe4=";
  };

  postPatch = ''
    substituteInPlace psycopg2cffi/_impl/_build_libpq.py \
      --replace-fail "from distutils import sysconfig" "import sysconfig" \
      --replace-fail "sysconfig.get_python_inc()" "sysconfig.get_path('include')"
  '';

  build-system = [
    postgresql
    setuptools
  ];

  dependencies = [
    cffi
    six
  ];

  # FATAL: could not create shared memory segment: Operation not permitted
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    postgresqlTestHook
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: '{}' != []
    "testEmptyArray"
  ];

  env = {
    PGDATABASE = "psycopg2_test";
  };

  pythonImportsCheck = [ "psycopg2cffi" ];

  meta = with lib; {
    description = "Implementation of the psycopg2 module using cffi";
    homepage = "https://pypi.org/project/psycopg2cffi/";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
