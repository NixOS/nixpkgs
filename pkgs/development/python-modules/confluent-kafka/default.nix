{ stdenv, buildPythonPackage, fetchPypi, isPy3k, rdkafka, requests, avro3k, avro, futures, enum34 }:

buildPythonPackage rec {
  version = "1.5.0";
  pname = "confluent-kafka";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ac812006000887f76c95b8a33a9f0b65845bf072fbc54a42a1acffd34e41120";
  };

  buildInputs = [ rdkafka requests ] ++ (if isPy3k then [ avro3k ] else [ enum34 avro futures ]) ;

  # No tests in PyPi Tarball
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Confluent's Apache Kafka client for Python";
    homepage = "https://github.com/confluentinc/confluent-kafka-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
