{ lib, buildPythonPackage, fetchPypi, isPy3k, rdkafka, requests, avro3k, avro, futures, enum34 }:

buildPythonPackage rec {
  version = "1.6.1";
  pname = "confluent-kafka";

  src = fetchPypi {
    inherit pname version;
    sha256 = "800f9cf5ec421dab82c01355bfa9ed819b70d70b01ca1e41c0f8526e5f340ddf";
  };

  buildInputs = [ rdkafka requests ] ++ (if isPy3k then [ avro3k ] else [ enum34 avro futures ]) ;

  # No tests in PyPi Tarball
  doCheck = false;

  meta = with lib; {
    description = "Confluent's Apache Kafka client for Python";
    homepage = "https://github.com/confluentinc/confluent-kafka-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
