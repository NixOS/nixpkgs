{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "python-sql";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f0g10y0whvax8yv0rfs7b4yd68lbxbss1za0mvbvr65b8r3pdxz";
  };

  meta = {
    homepage = https://python-sql.tryton.org/;
    description = "A library to write SQL queries in a pythonic way";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.bsd3;
  };
}
