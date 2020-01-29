{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "python-sql";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05ni936y0ia9xmryl7mlhbj9i80nnvq1bi4zxhb96rv7yvpb3fqb";
  };

  meta = {
    homepage = https://python-sql.tryton.org/;
    description = "A library to write SQL queries in a pythonic way";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.bsd3;
  };
}
