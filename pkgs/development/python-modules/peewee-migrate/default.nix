{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# runtime
, cached-property
, click
, peewee

# tests
, psycopg2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "peewee-migrate";
  version = "1.6.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "klen";
    repo = "peewee_migrate";
    rev = "refs/tags/${version}";
    hash = "sha256-gUtxsvPj8pwzijia313d553j9U2LP5vKJHxVU1SqsV8=";
  };

  postPatch = ''
    sed -i '/addopts/d' setup.cfg
  '';

  propagatedBuildInputs = [
    peewee
    click
  ] ++ lib.optionals (pythonOlder "3.8") [
    cached-property
  ];

  pythonImportsCheck = [
    "peewee_migrate"
  ];

  nativeCheckInputs = [
    psycopg2
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Simple migration engine for Peewee";
    homepage = "https://github.com/klen/peewee_migrate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
