{ lib, buildPythonPackage, fetchPypi, isPy3k, rdkafka, requests, avro3k, avro ? null, futures ? null, enum34 ? null }:

buildPythonPackage rec {
  version = "1.8.2";
  pname = "confluent-kafka";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b79e836c3554bc51c6837a8a0152f7521c9bf31342f5b8e21eba6b28044fa585";
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
