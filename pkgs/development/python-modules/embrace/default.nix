{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromSourcehut,
  pytestCheckHook,
  sqlparse,
  wrapt,
}:

buildPythonPackage rec {
  pname = "embrace";
  version = "4.2.1";
  format = "setuptools";

  src = fetchFromSourcehut {
    vc = "hg";
    owner = "~olly";
    repo = "embrace-sql";
    rev = "v${version}-release";
    hash = "sha256-B/xW5EfaQWW603fjKYcf+RHQJVZrnFoqVnIl6xSwS0E=";
  };

  propagatedBuildInputs = [
    sqlparse
    wrapt
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "embrace" ];

  # Some test for hot-reload fails on Darwin, but the rest of the library
  # should remain usable. (https://todo.sr.ht/~olly/embrace-sql/4)
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Embrace SQL keeps your SQL queries in SQL files";
    homepage = "https://pypi.org/project/embrace/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ euxane ];
  };
}
