{ buildPythonPackage, fetchPypi, stdenv, py4j }:

buildPythonPackage rec {
  pname = "pyspark";
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7fb3b4fe47edb0fb78cecec37e0f2a728590f17ef6a49eae55141a7a374c07c8";
  };

  # pypandoc is broken with pandoc2, so we just lose docs.
  postPatch = ''
    sed -i "s/'pypandoc'//" setup.py
  '';

  propagatedBuildInputs = [ py4j ];

  # Tests assume running spark...
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Apache Spark";
    homepage = https://github.com/apache/spark/tree/master/python;
    license = licenses.asl20;
    maintainers = [ maintainers.shlevy ];
  };
}
