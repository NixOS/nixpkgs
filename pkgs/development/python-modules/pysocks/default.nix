{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pysocks";
  version = "1.6.8";

  src = fetchPypi {
    pname = "PySocks";
    inherit version;
    sha256 = "3fe52c55890a248676fd69dc9e3c4e811718b777834bcaab7a8125cf9deac672";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "SOCKS module for Python";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ thoughtpolice ];
  };

}
