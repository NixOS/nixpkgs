{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

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
  version = "1.13.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "klen";
    repo = "peewee_migrate";
    rev = "refs/tags/${version}";
    hash = "sha256-sC63WH/4EmoQYfvl3HyBHDzT/jMZW/G7mTC138+ZHHU=";
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

  meta = with lib; {
    description = "Simple migration engine for Peewee";
    homepage = "https://github.com/klen/peewee_migrate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
