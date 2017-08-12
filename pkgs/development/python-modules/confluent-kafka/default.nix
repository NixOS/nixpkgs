{ stdenv, buildPythonPackage, fetchPypi, isPy3k, rdkafka, requests, avro3k, avro}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  version = "0.9.4";
  pname = "confluent-kafka";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v8apw9f8l01ql42jg1sfqv41yxvcbxn1a3ar01y0ni428swq6wk";
  };

  buildInputs = [ rdkafka requests ] ++ (if isPy3k then [ avro3k ] else [ avro ]) ;

  # Tests fail for python3 under this pypi release
  doCheck = if isPy3k then false else true;

  meta = with stdenv.lib; {
    description = "Confluent's Apache Kafka client for Python";
    homepage = https://github.com/confluentinc/confluent-kafka-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
