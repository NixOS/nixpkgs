{ stdenv, buildPythonPackage, fetchPypi, isPy3k, rdkafka, requests, avro3k, avro, futures}:

buildPythonPackage rec {
  version = "0.11.5";
  pname = "confluent-kafka";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfb5807bfb5effd74f2cfe65e4e3e8564a9e72b25e099f655d8ad0d362a63b9f";
  };

  buildInputs = [ rdkafka requests ] ++ (if isPy3k then [ avro3k ] else [ avro futures ]) ;

  # Tests fail for python3 under this pypi release
  doCheck = if isPy3k then false else true;

  meta = with stdenv.lib; {
    description = "Confluent's Apache Kafka client for Python";
    homepage = https://github.com/confluentinc/confluent-kafka-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
