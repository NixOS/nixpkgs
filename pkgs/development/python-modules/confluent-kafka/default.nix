{ stdenv, buildPythonPackage, fetchPypi, isPy3k, rdkafka, requests, avro3k, avro, futures, enum34 }:

buildPythonPackage rec {
  version = "1.0.1";
  pname = "confluent-kafka";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04bsnyhldcvscdj0dg3hm5k27vmhfi9k6bwz963sd3q2h7g9k6kg";
  };

  buildInputs = [ rdkafka requests ] ++ (if isPy3k then [ avro3k ] else [ enum34 avro futures ]) ;

  # No tests in PyPi Tarball
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Confluent's Apache Kafka client for Python";
    homepage = https://github.com/confluentinc/confluent-kafka-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
