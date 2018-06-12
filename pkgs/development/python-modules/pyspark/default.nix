{ buildPythonPackage, fetchPypi, stdenv, py4j }:

buildPythonPackage rec {
  pname = "pyspark";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "52d77a7ef43088b0235742cfcafc83435d0d98c5fdded1d8c600f1887e9e0213";
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
