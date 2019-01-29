{ stdenv
, buildPythonPackage
, fetchurl
, isPy3k
}:

buildPythonPackage rec {
  pname = "qpid-python";
  version = "0.32";
  disabled = isPy3k;

  src = fetchurl {
    url = "http://www.us.apache.org/dist/qpid/${version}/${pname}-${version}.tar.gz";
    sha256 = "09hdfjgk8z4s3dr8ym2r6xn97j1f9mkb2743pr6zd0bnj01vhsv4";
  };

  # needs a broker running and then ./qpid-python-test
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://qpid.apache.org/;
    description = "Python client implementation and AMQP conformance tests for Apache Qpid";
    license = licenses.asl20;
  };

}
