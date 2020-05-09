{ buildPythonPackage, fetchPypi, stdenv, py4j }:

buildPythonPackage rec {
  pname = "pyspark";
  version = "2.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0deed5687828efdaf4091e748f0ba1ae8aad6e4c3a5f07aa07e19487397e0e07";
  };

  # pypandoc is broken with pandoc2, so we just lose docs.
  postPatch = ''
    sed -i "s/'pypandoc'//" setup.py

    # Current release works fine with py4j 0.10.8.1
    substituteInPlace setup.py --replace py4j==0.10.7 'py4j>=0.10.7,<0.11'
  '';

  propagatedBuildInputs = [ py4j ];

  # Tests assume running spark...
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Apache Spark";
    homepage = "https://github.com/apache/spark/tree/master/python";
    license = licenses.asl20;
    maintainers = [ maintainers.shlevy ];
  };
}
