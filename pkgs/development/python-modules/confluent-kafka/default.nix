{ stdenv, buildPythonPackage, fetchPypi, isPy3k, rdkafka, requests, avro3k, avro, futures}:

buildPythonPackage rec {
  version = "0.11.6";
  pname = "confluent-kafka";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dvzlafgr4g0n7382s5bgbls3f9wrgr0yxd70yyxl59wddwzfii7";
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
