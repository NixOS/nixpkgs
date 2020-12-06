{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "python-sql";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "306999bd311fbf50804d76f346655af0a6ff18881ce46c1329256fee40f492c0";
  };

  meta = {
    homepage = "https://python-sql.tryton.org/";
    description = "A library to write SQL queries in a pythonic way";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.bsd3;
  };
}
