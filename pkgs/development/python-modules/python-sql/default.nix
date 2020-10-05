{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "python-sql";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bde7cd0e83bf90d1d9683c97ec83c0a656353cb7ff3cd788553c34b8f8b8c302";
  };

  meta = {
    homepage = "https://python-sql.tryton.org/";
    description = "A library to write SQL queries in a pythonic way";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.bsd3;
  };
}
