{ lib, buildPythonPackage, fetchPypi, freetds, cython, setuptools-git }:

buildPythonPackage rec {
  pname = "pymssql";
  version = "2.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yvs3azd8dkf40lybr9wvswvf4hbxn5ys9ypansmbbb328dyn09j";
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
