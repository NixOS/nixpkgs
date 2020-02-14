{ lib, buildPythonPackage, fetchPypi, freetds, cython, setuptools-git }:

buildPythonPackage rec {
  pname = "pymssql";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d0ed31c76983d723c0c979b18e2273623621e630ca4901f17a86128aca13f84";
  };

  buildInputs = [cython setuptools-git];
  propagatedBuildInputs = [freetds];

  # The tests require a running instance of SQLServer, so we skip them
  doCheck = false;

  meta = with lib; {
    homepage = http://pymssql.org/en/stable/;
    description = "A simple database interface for Python that builds on top
      of FreeTDS to provide a Python DB-API (PEP-249) interface to Microsoft
      SQL Server";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ mredaelli ];
  };
}
