{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "python-sql";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d916357a0172c35eccac29064cd18cd41616fc60109a37dac0e9d11a0b1183a";
  };

  meta = {
    homepage = "https://python-sql.tryton.org/";
    description = "A library to write SQL queries in a pythonic way";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.bsd3;
  };
}
