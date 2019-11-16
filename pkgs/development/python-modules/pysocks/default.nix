{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pysocks";
  version = "1.7.0";

  src = fetchPypi {
    pname = "PySocks";
    inherit version;
    sha256 = "0z4p31bpqm893cf87qqgb30k7nwd8kqfjwwjm5cvxb6zbyj1w0yr";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "SOCKS module for Python";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ thoughtpolice ];
  };

}
