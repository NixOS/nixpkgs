{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pysocks";
  version = "1.7.1";

  src = fetchPypi {
    pname = "PySocks";
    inherit version;
    sha256 = "184sg65mbmih6ljblfsxcmq5js5l7dj3gpn618w9q5dy3rbh921z";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "SOCKS module for Python";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ thoughtpolice ];
  };

}
