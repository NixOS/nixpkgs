{ buildPythonPackage, fetchPypi, stdenv, py4j }:

buildPythonPackage rec {
  pname = "pyspark";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vlq07yqy6c7ayg401i0qynnliqz405bmw1r8alkck0m1s8kcd8b";
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
