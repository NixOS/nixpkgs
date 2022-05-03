{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "python-sql";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-b+dkCC9IiR2Ffqfm+kJfpU8TUx3fa4nyTAmOZGrRtLY=";
  };

  meta = {
    homepage = "https://python-sql.tryton.org/";
    description = "A library to write SQL queries in a pythonic way";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.bsd3;
  };
}
