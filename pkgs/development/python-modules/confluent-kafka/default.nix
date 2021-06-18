{ lib, buildPythonPackage, fetchPypi, isPy3k, rdkafka, requests, avro3k, avro ? null, futures ? null, enum34 ? null }:

buildPythonPackage rec {
  version = "1.7.0";
  pname = "confluent-kafka";

  src = fetchPypi {
    inherit pname version;
    sha256 = "80e01b4791513c27eded8517af847530dfdf04c43d99ff132ed9c3085933b75b";
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
