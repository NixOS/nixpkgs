{ lib, buildPythonPackage, fetchPypi, isPy3k, rdkafka, requests, avro3k, avro ? null, futures ? null, enum34 ? null }:

buildPythonPackage rec {
  version = "1.6.0";
  pname = "confluent-kafka";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a9caabdb02e87cd65c7f10f689ba3f1a15f8774de455e96fa5fc56eecfee63c";
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
