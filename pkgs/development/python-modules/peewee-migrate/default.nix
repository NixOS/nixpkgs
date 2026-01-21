{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # runtime
  click,
  peewee,

  # tests
  psycopg2,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "peewee-migrate";
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klen";
    repo = "peewee_migrate";
    tag = version;
    hash = "sha256-WO6XTlHenEh8gO1eYJHaysQFMMmAOAdHYcISBZaNcrE=";
  };

  postPatch = ''
    sed -i '/addopts/d' pyproject.toml
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    peewee
    click
  ];

  pythonImportsCheck = [ "peewee_migrate" ];

  nativeCheckInputs = [
    psycopg2
    pytestCheckHook
  ];

  disabledTests = [
    #  sqlite3.OperationalError: error in table order after drop column...
    "test_migrator"
  ];

  meta = {
    description = "Simple migration engine for Peewee";
    homepage = "https://github.com/klen/peewee_migrate";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
