{ lib, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  name = "python-sql-${version}";
  version = "0.8";
  src = fetchurl {
    url = "mirror://pypi/p/python-sql/${name}.tar.gz";
    sha256 = "0xik939sxqfqqbpgcsnfjnws692bjip32khgwhq1ycphfy7df3h2";
  };
  meta = {
    homepage = http://python-sql.tryton.org/;
    description = "A library to write SQL queries in a pythonic way";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.bsd3;
  };
}
