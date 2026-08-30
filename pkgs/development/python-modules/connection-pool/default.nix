{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "connection-pool";
  version = "0.0.3";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    pname = "connection_pool";
    inherit version;
    hash = "sha256-v0Keeu9lkhxptO1I89SNPqwTg7BdLfkYhHBYQtl00Nw=";
  };

  doCheck = false; # no tests
  pythonImportsCheck = [ "connection_pool" ];

  meta = {
    description = "Thread-safe connection pool";
    homepage = "https://github.com/zhouyl/ConnectionPool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
