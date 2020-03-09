{ stdenv, buildPythonPackage, fetchPypi, isPy3k, rdkafka, requests, avro3k, avro, futures, enum34 }:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "confluent-kafka";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4025ccddbc79443a4e2342de0d770f669558eb737fca2e7851558cd45f78ef78";
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
