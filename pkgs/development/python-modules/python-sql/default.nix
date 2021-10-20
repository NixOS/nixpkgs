{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "python-sql";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d603a6273f2f5966bab7ce77e1f50e88818d5237ac85e566e2dc84ebfabd176";
  };

  meta = {
    homepage = "https://python-sql.tryton.org/";
    description = "A library to write SQL queries in a pythonic way";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.bsd3;
  };
}
