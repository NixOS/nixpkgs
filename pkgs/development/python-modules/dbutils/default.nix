{ lib, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  version = "2.0";
  pname = "dbutils";

  src = fetchPypi {
    inherit version;
    pname = "DBUtils";
    sha256 = "131ifm2c2a7bipij597i8fvjka0dk2qv1xr2ghcvbc30jlkvag2g";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Database connections for multi-threaded environments";
    homepage = "https://webwareforpython.github.io/DBUtils/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
