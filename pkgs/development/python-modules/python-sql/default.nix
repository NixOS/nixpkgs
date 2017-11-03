{ lib, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  pname = "python-sql";
  name = "${pname}-${version}";
  version = "0.9";
  src = fetchurl {
    url = "mirror://pypi/p/python-sql/${name}.tar.gz";
    sha256 = "07b51cc1c977ef5480fe671cae5075ad4b68a6fc67f4569782e06f012456d35c";
  };
  meta = {
    homepage = http://python-sql.tryton.org/;
    description = "A library to write SQL queries in a pythonic way";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.bsd3;
  };
}
