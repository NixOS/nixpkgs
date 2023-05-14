{ lib, buildPythonPackage, fetchPypi, isPy3k, rdkafka, requests, avro3k, avro ? null, futures ? null, enum34 ? null }:

buildPythonPackage rec {
  version = "2.0.2";
  pname = "confluent-kafka";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OzQupCJu0QXKi8A1sId+TcLxFf/adOOjUPNjaDNWUVs=";
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
