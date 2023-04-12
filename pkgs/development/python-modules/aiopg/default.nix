{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, psycopg2
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiopg";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GD5lRSUjASTwBk5vEK8v3xD8eNyxpwSrO3HHvtwubmk=";
  };

  propagatedBuildInputs = [
    async-timeout
    psycopg2
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "psycopg2-binary" "psycopg2"
  '';

  # Tests requires a PostgreSQL Docker instance
  doCheck = false;

  pythonImportsCheck = [
    "aiopg"
  ];

  meta = with lib; {
    description = "Python library for accessing a PostgreSQL database";
    homepage = "https://aiopg.readthedocs.io/";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
