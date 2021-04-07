{ buildPythonPackage, fetchPypi, lib, py4j }:

buildPythonPackage rec {
  pname = "pyspark";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "104abc146d4ffb72d4c683d25d7af5a6bf955d94590a76f542ee23185670aa7e";
  };

  # pypandoc is broken with pandoc2, so we just lose docs.
  postPatch = ''
    sed -i "s/'pypandoc'//" setup.py

    substituteInPlace setup.py --replace py4j==0.10.9 'py4j>=0.10.9,<0.11'
  '';

  propagatedBuildInputs = [ py4j ];

  # Tests assume running spark...
  doCheck = false;

  meta = with lib; {
    description = "Apache Spark";
    homepage = "https://github.com/apache/spark/tree/master/python";
    license = licenses.asl20;
    maintainers = [ maintainers.shlevy ];
  };
}
