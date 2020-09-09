{ buildPythonPackage, fetchPypi, stdenv, py4j }:

buildPythonPackage rec {
  pname = "pyspark";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c6e5cc51d91eb8d43e81d0b7093292b5e144ac81445491d5f887d2cf4fe121f";
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
